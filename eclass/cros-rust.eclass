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
: ${CROS_RUST_EMPTY_CRATE:=}

inherit toolchain-funcs cros-debug

EXPORT_FUNCTIONS src_unpack src_install

DEPEND="
	>=virtual/rust-1.28.0:=
	>=dev-util/cargo-0.29.0
"

ECARGO_HOME="${WORKDIR}/cargo_home"
CROS_RUST_REGISTRY_DIR="/usr/lib/cros_rust_registry"

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

		[dependencies]
		EOF

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

	[target.${CBUILD}]
	linker = "$(tc-getBUILD_CC)"
	EOF
}

# @FUNCTION: ecargo
# @USAGE: <args to cargo>
# @DESCRIPTION:
# Call cargo with the specified command line options.
ecargo() {
	debug-print-function ${FUNCNAME} "$@"

	export CARGO_TARGET_DIR="${WORKDIR}"
	export CARGO_HOME="${ECARGO_HOME}"
	export HOST="${CBUILD}"
	export HOST_CC="$(tc-getBUILD_CC)"
	export TARGET="${CHOST}"
	export TARGET_CC="$(tc-getCC)"

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
	ecargo build --target="${CHOST}" $(usex cros-debug "" --release) "$@"
}

# @FUNCTION: ecargo_test
# @USAGE: <args to cargo test>
# @DESCRIPTION:
# Call `cargo test` with the specified command line options.
ecargo_test() {
	ecargo test --target="${CHOST}" $(usex cros-debug "" --release) "$@"
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
	ecargo package --allow-dirty --no-metadata --no-verify --no-vcs || die

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

cros-rust_src_install() {
	debug-print-function ${FUNCNAME} "$@"

	cros-rust_publish
}

fi
