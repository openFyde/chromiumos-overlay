# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: cros-rust.eclass
# @MAINTAINER:
# The Chromium OS Authors <chromium-os-dev@chromium.org>
# @BUGREPORTS:
# Please report bugs via https://crbug.com/new (with component "Tools>ChromeOS-Toolchain")
# @VCSURL: https://chromium.googlesource.com/chromiumos/overlays/chromiumos-overlay/+/master/eclass/@ECLASS@
# @BLURB: Eclass for fetching, building, and installing Rust packages.

if [[ -z ${_ECLASS_CROS_RUST} ]]; then
_ECLASS_CROS_RUST="1"

# Check for EAPI 6+.
case "${EAPI:-0}" in
[012345]) die "unsupported EAPI (${EAPI}) in eclass (${ECLASS})" ;;
esac

# @ECLASS-VARIABLE: CROS_RUST_EMPTY_CRATE
# @PRE_INHERIT
# @DESCRIPTION:
# Indicates that this package is an empty crate for satisfying cargo's
# requirements but will not actually be used during compile time.  Used by
# dev-dependencies or crates like winapi.
: "${CROS_RUST_EMPTY_CRATE:=}"

# @ECLASS-VARIABLE: CROS_RUST_EMPTY_CRATE_FEATURES
# @PRE_INHERIT
# @DESCRIPTION:
# Array of Cargo features emitted into the Cargo.toml of an empty crate. Allows
# downstream crates to depend on this crate with the given features enabled.
if [[ ! -v CROS_RUST_EMPTY_CRATE_FEATURES ]]; then
	CROS_RUST_EMPTY_CRATE_FEATURES=()
fi

# @ECLASS-VARIABLE: CROS_RUST_OVERFLOW_CHECKS
# @PRE_INHERIT
# @DESCRIPTION:
# Enable integer overflow checks for this package.  Packages that wish to
# disable integer overflow checks should set this value to 0.  Integer overflow
# checks are always enabled when the cros-debug flag is set.
: "${CROS_RUST_OVERFLOW_CHECKS:=1}"

# @ECLASS-VARIABLE: CROS_RUST_REMOVE_DEV_DEPS
# @PRE_INHERIT
# @DESCRIPTION:
# Removes all the dev-dependencies from the Cargo.toml. This can break circular
# dependencies and help minimize how many dependent packages need to be added.
: "${CROS_RUST_REMOVE_DEV_DEPS:=}"

inherit toolchain-funcs cros-debug cros-sanitizers

IUSE="asan fuzzer lsan +lto msan test tsan ubsan"
REQUIRED_USE="?? ( asan lsan msan tsan )"

EXPORT_FUNCTIONS src_unpack src_prepare src_configure src_install

DEPEND="
	>=virtual/rust-1.28.0:=
	>=dev-util/cargo-0.29.0
"

ECARGO_HOME="${WORKDIR}/cargo_home"
CROS_RUST_REGISTRY_DIR="/usr/lib/cros_rust_registry"

# Ignore odr violations in unit tests in asan builds
# (https://github.com/rust-lang/rust/issues/41807).
ASAN_OPTIONS="detect_odr_violation=0"

# @FUNCTION: cargo_src_unpack
# @DESCRIPTION:
# Unpacks the package
cros-rust_src_unpack() {
	debug-print-function ${FUNCNAME} "$@"

	local archive
	for archive in ${A}; do
		case "${archive}" in
			*.crate)
				ebegin "Unpacking ${archive}"

				ln -s "${DISTDIR}/${archive}" "${archive}.tar"
				unpack "./${archive}.tar"
				rm "${archive}.tar"

				eend $?
				;;
			*)
				unpack "${archive}"
				;;
		esac
	done

	if [[ "${CROS_RUST_EMPTY_CRATE}" == "1" ]]; then
		# Generate an empty Cargo.toml and src/lib.rs for this crate.
		mkdir -p "${S}/src"
		cat <<- EOF >> "${S}/Cargo.toml"
		[package]
		name = "${PN}"
		version = "${PV}"
		authors = ["The Chromium OS Authors"]

		[features]
		EOF

		if [[ "$(declare -p CROS_RUST_EMPTY_CRATE_FEATURES 2> /dev/null)" != "declare -a"* ]]; then
			eerror "CROS_RUST_EMPTY_CRATE_FEATURES must be an array"
			die
		fi

		local feature
		for feature in "${CROS_RUST_EMPTY_CRATE_FEATURES[@]}"; do
			echo "${feature} = []" >> "${S}/Cargo.toml"
		done

		touch "${S}/src/lib.rs"
	fi

	# Set up the cargo config.
	mkdir -p "${ECARGO_HOME}"

	cat <<- EOF > "${ECARGO_HOME}/config"
	[source.chromeos]
	directory = "${SYSROOT}/${CROS_RUST_REGISTRY_DIR}"

	[source.crates-io]
	replace-with = "chromeos"
	local-registry = "/nonexistent"

	[target.${CHOST}]
	linker = "$(tc-getCC)"
	EOF

	# When the target environment is different from the host environment,
	# add a setting for the target environment.
	if tc-is-cross-compiler; then
		cat <<- EOF >> "${ECARGO_HOME}/config"

		[target.${CBUILD}]
		linker = "$(tc-getBUILD_CC)"
		EOF
	fi
}

# @FUNCTION: cros-rust_src_prepare
# @DESCRIPTION:
# Prepares the src. This function supports "# provided by ebuild" macro and
# "# ignored by ebuild" macro for replacing and removing path dependencies
# with ones provided by their ebuild in Cargo.toml
# and Cargo.toml will be modified in place. If the macro is used in
# ${S}/Cargo.toml, CROS_WORKON_OUTOFTREE_BUILD can't be set to 1 in its ebuild.
cros-rust_src_prepare() {
	if grep -q "# provided by ebuild" "${S}/Cargo.toml"; then
		if [[ "${CROS_WORKON_OUTOFTREE_BUILD}" == 1 ]]; then
			die 'CROS_WORKON_OUTOFTREE_BUILD=1 must not be set when using' \
				'`provided by ebuild`'
		fi

		# Replace path dependencies with ones provided by their ebuild.
		#
		# For local developer builds, we want Cargo.toml to contain path
		# dependencies on sibling crates within the same repository or elsewhere
		# in the Chrome OS source tree. This enables developers to run `cargo
		# build` and have dependencies resolve correctly to their locally
		# checked out code.
		#
		# At the same time, some crates contained within the crosvm repository
		# have their own ebuild independent of the crosvm ebuild so that they
		# are usable from outside of crosvm. Ebuilds of downstream crates won't
		# be able to depend on these crates by path dependency because that
		# violates the build sandbox. We perform a sed replacement to eliminate
		# the path dependency during ebuild of the downstream crates.
		#
		# The sed command says: in any line containing `# provided by ebuild`,
		# please replace `path = "..."` with `version = "*"`. The intended usage
		# is like this:
		#
		#     [dependencies]
		#     data_model = { path = "../data_model" }  # provided by ebuild
		#
		sed -i \
			'/# provided by ebuild$/ s/path = "[^"]*"/version = "*"/' \
			"${S}/Cargo.toml" || die
	fi

	if grep -q "# ignored by ebuild" "${S}/Cargo.toml"; then
		if [[ "${CROS_WORKON_OUTOFTREE_BUILD}" == 1 ]]; then
			die 'CROS_WORKON_OUTOFTREE_BUILD=1 must not be set when using' \
				'`ignored by ebuild`'
		fi
		# Emerge ignores "out-of-sandbox" [patch.crates-io] lines in
		# Cargo.toml.
		sed -i \
			'/# ignored by ebuild/d' \
			"${S}/Cargo.toml" || die
	fi

	# Remove lines that start with "[dev-dependencies." until a line is found that
	# starts with "[" but not "[dev-d".
	#
	# The sed script is of the form '/A/,/B/{/B/!d}'.
	# The first part '/A/,/B/' includes lines that match /A/ and following lines
	# until a line matches the second pattern /B/ inclusive. The last part,
	# {/B/!d} deletes included lines that don't match /B/.
	#
	# The first pattern /^\[dev-dependencies\./ is fairly easy to understand. it
	# matches any line that begins with "[dev-dependencies." The second pattern
	# would ideally be /^[/ which would match any line that starts with "[".
	# unfortunately that also matches the first pattern so the range would always
	# be one line. To avoid this problem the second pattern approximates a check
	# to make sure the first pattern isn't matched. It does so by testing to see
	# if the string that follows the "[" doesn't match "dev-d". This is
	# accomplished by matching strings that don't begin with "d", or begin with
	# "d" but don't begin with "de", or begin with "de" but don't begin with
	# "dev", ... or begin with "dev-" but don't begin with "dev-d".
	if [[ "${CROS_RUST_REMOVE_DEV_DEPS}" == 1 ]]; then
		local neg_pattern='/^\[($|[^d]|d($|[^e]|e($|[^v]|v($|[^-]|-($|[^d])))))/'
		sed -i -E \
			"/^\\[dev-dependencies\\./,${neg_pattern}{${neg_pattern}!d}" \
			"${S}/Cargo.toml" || die
	fi

	default
}

# @FUNCTION: cros-rust_src_configure
# @DESCRIPTION:
# Configures the source and exports any environment variables needed during the
# build.
cros-rust_src_configure() {
	sanitizers-setup-env

	export CARGO_TARGET_DIR="${WORKDIR}"
	export CARGO_HOME="${ECARGO_HOME}"
	export HOST="${CBUILD}"
	export HOST_CC="$(tc-getBUILD_CC)"
	# PKG_CONFIG_ALLOW_CROSS is required by pkg-config.
	# https://github.com/rust-lang/pkg-config-rs/issues/41.
	# Since cargo will overwrites $HOST with "" when building pkg-config, we
	# need to set it regardless of the value of tc-is-cross-compiler here.
	export PKG_CONFIG_ALLOW_CROSS=1
	export TARGET="${CHOST}"
	export TARGET_CC="$(tc-getCC)"

	# There is a memory leak in libbacktrace:
	# https://github.com/rust-lang/rust/issues/59125
	cros-rust_use_sanitizers || export RUST_BACKTRACE=1

	# We want debug info even in release builds.
	local rustflags=(
		-Cdebuginfo=2
		-Copt-level=3
	)

	use lto && rustflags+=( -Clto )

	# We don't want to abort during tests.
	use test || rustflags+=( -Cpanic=abort )

	if use cros-debug || [[ "${CROS_RUST_OVERFLOW_CHECKS}" == "1" ]]; then
		rustflags+=( -Coverflow-checks=on )
	fi

	use cros-debug && rustflags+=( -Cdebug-assertions=on )

	use asan && rustflags+=( -Csanitizer=address )
	use lsan && rustflags+=( -Csanitizer=leak )
	use msan && rustflags+=( -Csanitizer=memory )
	use tsan && rustflags+=( -Csanitizer=thread )
	use ubsan && rustflags+=( -Clink-arg=-fsanitize=undefined )

	if use fuzzer; then
		rustflags+=(
			--cfg fuzzing
			-Cpasses=sancov
			-Cllvm-args=-sanitizer-coverage-level=4
			-Cllvm-args=-sanitizer-coverage-inline-8bit-counters
			-Cllvm-args=-sanitizer-coverage-trace-compares
			-Cllvm-args=-sanitizer-coverage-pc-table
			-Cllvm-args=-sanitizer-coverage-trace-divs
			-Cllvm-args=-sanitizer-coverage-trace-geps
			-Cllvm-args=-sanitizer-coverage-prune-blocks=0
		)
	fi

	export RUSTFLAGS="${rustflags[*]}"
}

# @FUNCTION: cros-rust_use_sanitizers
# @DESCRIPTION:
# Checks whether sanitizers are being used.
cros-rust_use_sanitizers() {
	use_sanitizers || use lsan
}

# @FUNCTION: ecargo
# @USAGE: <args to cargo>
# @DESCRIPTION:
# Call cargo with the specified command line options.
ecargo() {
	debug-print-function ${FUNCNAME} "$@"

	# The cargo developers have decided to make it as painful as possible to
	# use cargo inside another build system.  So there is no way to tell
	# cargo to just not write this lock file.  Instead we have to bend over
	# backwards to accommodate cargo.
	addwrite Cargo.lock
	rm -f Cargo.lock

	cargo -v "$@" || die

	# Now remove any Cargo.lock files that cargo pointlessly created.
	rm -f Cargo.lock
}

# @FUNCTION: ecargo_build
# @USAGE: <args to cargo build>
# @DESCRIPTION:
# Call `cargo build` with the specified command line options.
ecargo_build() {
	ecargo build --target="${CHOST}" --release "$@"
}

# @FUNCTION: ecargo_build_fuzzer
# @DESCRIPTION:
# Call `cargo build` with fuzzing options enabled.
ecargo_build_fuzzer() {
	local fuzzer_libdir="$(dirname "$($(tc-getCC) -print-libgcc-file-name)")"
	local fuzzer_arch="${ARCH}"
	if [[ "${ARCH}" == "amd64" ]]; then
		fuzzer_arch="x86_64"
	fi

	local link_args=(
		-Clink-arg="-L${fuzzer_libdir}"
		-Clink-arg="-lclang_rt.fuzzer-${fuzzer_arch}"
		-Clink-arg="-lc++"
		-Clink-arg="-Wl,-export-dynamic"
	)

	# The `rustc` subcommand for cargo allows us to set some extra flags for
	# the current package without setting them for all `rustc` invocations.
	# On the other hand the flags in the RUSTFLAGS environment variable are set
	# for all `rustc` invocations.
	ecargo rustc --target="${CHOST}" --release "$@" -- "${link_args[@]}"
}

# @FUNCTION: ecargo_test
# @USAGE: <args to cargo test>
# @DESCRIPTION:
# Call `cargo test` with the specified command line options.
ecargo_test() {
	ecargo test --target="${CHOST}" --target-dir "${CARGO_TARGET_DIR}/ecargo-test" --release "$@"
}

# @FUNCTION: cros-rust_publish
# @USAGE: [crate name] [crate version]
# @DESCRIPTION:
# Publish a library crate to the local registry.  Should only be called from
# within a src_install() function.
cros-rust_publish() {
	debug-print-function ${FUNCNAME} "$@"

	local name="${1:-${PN}}"
	local version="${2:-${PV}}"

	# Create the .crate file.
	ecargo package --allow-dirty --no-metadata --no-verify || die

	# Unpack the crate we just created into the directory registry.
	local crate="${CARGO_TARGET_DIR}/package/${name}-${version}.crate"

	mkdir -p "${D}/${CROS_RUST_REGISTRY_DIR}"
	pushd "${D}/${CROS_RUST_REGISTRY_DIR}" > /dev/null
	tar xf "${crate}" || die

	# Calculate the sha256sum since cargo will want this later.
	local shasum="$(sha256sum ${crate} | cut -d ' ' -f 1)"
	local dir="${name}-${version}"
	local checksum="${T}/${name}-${version}-checksum.json"

	# Calculate the sha256 hashes of all the files in the crate.
	local files=( $(find "${dir}" -type f) )

	[[ "${#files[@]}" == "0" ]] && die "Could not find crate files for ${name}"

	# Now start filling out the checksum file.
	printf '{\n\t"package": "%s",\n\t"files": {\n' "${shasum}" > "${checksum}"
	local idx=0
	local f
	for f in "${files[@]}"; do
		shasum="$(sha256sum ${f} | cut -d ' ' -f 1)"
		printf '\t\t"%s": "%s"' "${f#${dir}/}" "${shasum}" >> "${checksum}"

		# The json parser is unnecessarily strict about not allowing
		# commas on the last line so we have to track this ourselves.
		idx="$((idx+1))"
		if [[ "${idx}" == "${#files[@]}" ]]; then
			printf '\n' >> "${checksum}"
		else
			printf ',\n' >> "${checksum}"
		fi
	done
	printf "\t}\n}\n" >> "${checksum}"
	popd > /dev/null

	insinto "${CROS_RUST_REGISTRY_DIR}/${name}-${version}"
	newins "${checksum}" .cargo-checksum.json

	# We want the Cargo.toml.orig file to be world readable.
	fperms 0644 "${CROS_RUST_REGISTRY_DIR}/${name}-${version}/Cargo.toml.orig"
}

# @FUNCTION: cros-rust_get_build_dir
# @DESCRIPTION:
# Return the path to the directory where build artifacts are available.
cros-rust_get_build_dir() {
	echo "${CARGO_TARGET_DIR}/${CHOST}/release"
}

cros-rust_src_install() {
	debug-print-function ${FUNCNAME} "$@"

	cros-rust_publish
}

# @FUNCTION: cros-rust_get_crate_version
# @USAGE: <path to crate>
# @DESCRIPTION:
# Returns the version for a crate by finding the first 'version =' line in the
# Cargo.toml in the crate.
cros-rust_get_crate_version() {
	local crate="${1:-${S}}"
	[[ $# -gt 1 ]] && die "${FUNCNAME}: incorrect number of arguments"
	awk '/^version = / { print $3 }' "${crate}/Cargo.toml" | head -n1 | tr -d '"'
}

fi
