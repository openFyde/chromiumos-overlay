# Copyright 2022 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_RUST_REMOVE_DEV_DEPS=1

inherit cros-rust

DESCRIPTION='FFI bindings to gRPC c core library'
HOMEPAGE='https://github.com/tikv/grpc-rs'
SRC_URI="https://crates.io/api/v1/crates/${PN}/0.9.1+1.38.0/download -> grpcio-sys-0.9.1.crate"

LICENSE="Apache-2.0"
SLOT="${PV}/${PR}"
KEYWORDS="*"

DEPEND="
	=dev-rust/libc-0.2*:=
	>=dev-rust/libz-sys-1.1.3 <dev-rust/libz-sys-2.0.0_alpha:=
	=dev-rust/openssl-sys-0.9*:=
	=dev-rust/bindgen-0.59*:=
	=dev-rust/boringssl-src-0.3*:=
	=dev-rust/cc-1*:=
	=dev-rust/cmake-0.1*:=
	=dev-rust/pkg-config-0.3*:=
	>=dev-rust/walkdir-2.2.9 <dev-rust/walkdir-3.0.0_alpha:=
"
RDEPEND="${DEPEND}"

src_prepare() {
	#Update bindgen to 0.59.2 to match the one available in cros.  Default used by grpcio-sys is 0.57.0.
	elog "Using bindgen-0.59.2"
	eapply -p0 "${FILESDIR}"/001-bindgen-uprev.patch
	eapply_user
}

post_src_unpack() {
	elog "Moving ${S} to ${S}+1.38.0"
	mv "${S}+1.38.0" "${S}"
	if [[ -f "${S}/Cargo.toml.orig" ]]; then
		elog "Found Cargo.toml.orig which confilcts with build process (reserved name).  Removing."
		rm "${S}/Cargo.toml.orig"
	fi
}

src_install() {
	# Mostly copied from `cros-rust_publish stage` with some directory moves to account for b/240120958.
	elog "Overwrite cros-rust_publish stage"
	debug-print-function "${FUNCNAME[0]}" "$@"

	# Variable is inherited from cros-rust, but linter claims it is unassigned.
	# shellcheck disable=SC2154
	if [[ "${EBUILD_PHASE_FUNC}" != "src_install" ]]; then
		die "${FUNCNAME[0]}() should only be used in src_install() phase"
	fi

	local default_version="${CROS_RUST_CRATE_VERSION}"
	if [[ "${default_version}" == "9999" ]]; then
		# This triggers a linter error SC2119 which says:
		#   "Use foo "$@" if function's $1 should mean script's $1"
		# In this case, cros-rust_get_crate_version without arguments retrieves the
		# default value which is desired, so this warning can be ignored.
		# shellcheck disable=SC2119
		default_version="$(cros-rust_get_crate_version)"
	fi

	local name="${1:-${CROS_RUST_CRATE_NAME}}"
	local version="${2:-${default_version}}"

	# Create the .crate file.
	ecargo package --allow-dirty --no-metadata --no-verify --offline || die

	# Unpack the crate we just created into the directory registry.
	# Overwrite  Note: manual move here
	# Variable is inherited from cros-rust, but linter claims it is unassigned.
	# shellcheck disable=SC2154
	local crate_semver="${CARGO_TARGET_DIR}/package/${name}-${version}+1.38.0.crate"
	local crate="${CARGO_TARGET_DIR}/package/${name}-${version}.crate"
	mv "${crate_semver}" "${crate}"

	# Variable is inherited from cros-rust, but linter claims it is unassigned.
	# shellcheck disable=SC2154
	mkdir -p "${D}/${CROS_RUST_REGISTRY_DIR}"
	pushd "${D}/${CROS_RUST_REGISTRY_DIR}" > /dev/null || die
	tar xf "${crate}" || die

	# Calculate the sha256sum since cargo will want this later.
	local shasum="$(sha256sum "${crate}" | cut -d ' ' -f 1)"
	local dir="${name}-${version}"
	local checksum="${T}/${name}-${version}-checksum.json"

	# Overwrite Note: another mv.
	mv "${dir}+1.38.0" "${dir}"

	# Calculate the sha256 hashes of all the files in the crate.
	# This triggers a linter error SC2207 which says:
	#   "Prefer mapfile or read -a to split command
	#    output (or quote to avoid splitting)."
	# In this case, cros-rust_get_crate_version no argument retrieves the
	# default value which is desired, so this warning can be ignored.
	# shellcheck disable=SC2207
	local files=( $(find "${dir}" -type f) )

	[[ "${#files[@]}" == "0" ]] && die "Could not find crate files for ${name}"

	# Now start filling out the checksum file.
	printf '{\n\t"package": "%s",\n\t"files": {\n' "${shasum}" > "${checksum}"
	local idx=0
	local f
	for f in "${files[@]}"; do
		shasum="$(sha256sum "${f}" | cut -d ' ' -f 1)"
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
	popd > /dev/null || die

	insinto "${CROS_RUST_REGISTRY_DIR}/${name}-${version}"
	newins "${checksum}" .cargo-checksum.json

	# We want the Cargo.toml.orig file to be world readable.
	fperms 0644 "${CROS_RUST_REGISTRY_DIR}/${name}-${version}/Cargo.toml.orig"

	# Symlink the 9999 version to the version installed by the crate.
	if [[ "${CROS_RUST_CRATE_VERSION}" == "9999" && "${version}" != "9999" ]]; then
		dosym "${name}-${version}" "${CROS_RUST_REGISTRY_DIR}/${name}-9999"
	fi
}

# This file was automatically generated by cargo2ebuild.py.  Modified to account for appended semver.
# ${PV} was changed from the original 0.9.1+1.38.0
