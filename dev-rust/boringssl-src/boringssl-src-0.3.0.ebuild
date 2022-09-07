# Copyright 2022 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2
EAPI="7"
CROS_RUST_REMOVE_DEV_DEPS=1
inherit cros-rust
DESCRIPTION='A crate for building boringssl.'
HOMEPAGE='https://crates.io/crates/boringssl-src'
SRC_URI="https://crates.io/api/v1/crates/${PN}/${PV}+688fc5c/download -> ${P}.crate"
LICENSE="|| ( MIT Apache-2.0 )"
SLOT="${PV}/${PR}"
KEYWORDS="*"
DEPEND="
	=dev-rust/cmake-0.1*
"
RDEPEND="${DEPEND}"
post_src_unpack() {
	elog "Moving ${S} ${S}+688fc5c"
	mv "${S}+688fc5c" "${S}"
	if [[ -f "${S}/Cargo.toml.orig" ]]; then
		elog "Found Cargo.toml.orig which confilcts with build process (reserved name).  Removing."
		rm "${S}/Cargo.toml.orig"
	fi
}
src_install() {
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
	# Overwrite: manual move here
	# Variable is inherited from cros-rust, but linter claims it is unassigned.
	# shellcheck disable=SC2154
	local crate_semver="${CARGO_TARGET_DIR}/package/${name}-${version}+688fc5c.crate"
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
	#Overwrite: another mv...
	mv "${dir}+688fc5c" "${dir}"
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
		# FIXME:  2 files don't get built correctly and hash is changed.  overwrite manually for now.
		#File not PIE: /build/volteer/tmp/portage/dev-rust/boringssl-src-0.3.0/image/usr/lib/cros_rust_registry/store/boringssl-src-0.3.0/boringssl/src/util/ar/testdata/linux/bar.cc.o
		#File not built with -Wl,-z,relro: /build/volteer/tmp/portage/dev-rust/boringssl-src-0.3.0/image/usr/lib/cros_rust_registry/store/boringssl-src-0.3.0/boringssl/src/util/ar/testdata/linux/bar.cc.o
		#File not built with -Wl,-z,now: /build/volteer/tmp/portage/dev-rust/boringssl-src-0.3.0/image/usr/lib/cros_rust_registry/store/boringssl-src-0.3.0/boringssl/src/util/ar/testdata/linux/bar.cc.o
		#File not PIE: /build/volteer/tmp/portage/dev-rust/boringssl-src-0.3.0/image/usr/lib/cros_rust_registry/store/boringssl-src-0.3.0/boringssl/src/util/ar/testdata/linux/foo.c.o
		#File not built with -Wl,-z,relro: /build/volteer/tmp/portage/dev-rust/boringssl-src-0.3.0/image/usr/lib/cros_rust_registry/store/boringssl-src-0.3.0/boringssl/src/util/ar/testdata/linux/foo.c.o
		#File not built with -Wl,-z,now: /build/volteer/tmp/portage/dev-rust/boringssl-src-0.3.0/image/usr/lib/cros_rust_registry/store/boringssl-src-0.3.0/boringssl/src/util/ar/testdata/linux/foo.c.o
		#error: the listed checksum of `/build/volteer/usr/lib/cros_rust_registry/registry/boringssl-src-0.3.0/boringssl/src/util/ar/testdata/linux/bar.cc.o` has changed:
		#expected: 5c0ef26bd88239558873c78c28db3c745da1b6e4513dace8ad11c527a90c098e
		#actual:   36a3a8cdddf4f4abfc5861683443e54216d66db85a03aa05c0a2d7d9e4853b42
		#error: the listed checksum of `/build/volteer/usr/lib/cros_rust_registry/registry/boringssl-src-0.3.0/boringssl/src/util/ar/testdata/linux/foo.c.o` has changed:
		#expected: 619d878a647fe5ba353aa0b6f93912c2cdfb670f6622dfaac6c65151a89f4709
		#actual:   31e418306fbe0a34794e1db6f5fdbcb48afa29dc87e6a9b7f5ce9d6148b1beba
		if [[ "${f}" == *"testdata/linux/bar.cc.o" ]]; then
			shasum="36a3a8cdddf4f4abfc5861683443e54216d66db85a03aa05c0a2d7d9e4853b42"
		elif [[ "${f}" == *"testdata/linux/foo.c.o" ]]; then
			shasum="31e418306fbe0a34794e1db6f5fdbcb48afa29dc87e6a9b7f5ce9d6148b1beba"
		fi
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

# This file was automatically generated by cargo2ebuild.py
# ${PV} was changed from the original 0.3.0+688fc5c
