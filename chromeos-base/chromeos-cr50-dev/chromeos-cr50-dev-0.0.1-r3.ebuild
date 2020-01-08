# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE.makefile file.

EAPI="7"

CROS_WORKON_COMMIT=("f15eb886693218bb2bd8891fef0c3500ab537e56" "f4428141132ec85eb255a819fc5bdaea2303f6af" "e05bfa91102dd5137b4027b4f3405e041ffe2c32")
CROS_WORKON_TREE=("8dc884ee66e8ad4e42397166d3b03365731a156d" "4b0eaae00da0418755628097981bf4013f92a3a6" "1f42f6d549ba7b3f6bc5d67029984b113787ae0d")
CROS_WORKON_PROJECT=(
	"chromiumos/platform/ec"
	"chromiumos/third_party/tpm2"
	"chromiumos/third_party/cryptoc"
)
CROS_WORKON_LOCALNAME=(
	"platform/cr50"
	"third_party/tpm2"
	"third_party/cryptoc"
)
CROS_WORKON_DESTDIR=(
	"${S}/platform/ec"
	"${S}/third_party/tpm2"
	"${S}/third_party/cryptoc"
)

inherit toolchain-funcs cros-workon coreboot-sdk

DESCRIPTION="Google Security Chip firmware code"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/ec/+/refs/heads/cr50_stab"
MIRROR_PATH="gs://chromeos-localmirror/distfiles/"
CR50_ROS=(cr50.prod.ro.A.0.0.11 cr50.prod.ro.B.0.0.11)
SRC_URI="${CR50_ROS[*]/#/${MIRROR_PATH}}"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="quiet verbose fuzzer asan msan ubsan"

COMMON_DEPEND="
	fuzzer? (
		dev-libs/openssl:=
		dev-libs/protobuf:=
	)
"

RDEPEND="
	!<chromeos-base/chromeos-ec-0.0.2
	${COMMON_DEPEND}
"

# Need to control versions of chromeos-ec and chromeos-config packages to
# prevent file collision in /firmware/cr50.
DEPEND="
	${COMMON_DEPEND}
	fuzzer? ( dev-libs/libprotobuf-mutator:= )
"

# We don't want binchecks since we're cross-compiling firmware images using
# non-standard layout.
RESTRICT="binchecks"

# Cr50 signer manifest converted into proper json format.
CR50_JSON='prod.json'

src_unpack() {
	cros-workon_src_unpack
	S+="/platform/ec"
}

src_configure() {
	cros-workon_src_configure
}

set_build_env() {
	cros_use_gcc

	export CROSS_COMPILE=${COREBOOT_SDK_PREFIX_arm}

	tc-export CC BUILD_CC
	export HOSTCC=${CC}
	export BUILDCC=${BUILD_CC}

	EC_OPTS=()
	use quiet && EC_OPTS+=( -s 'V=0' )
	use verbose && EC_OPTS+=( 'V=1' )
}

#
# Convert internal representation of the signer manifest into conventional
# json.
#
prepare_cr50_signer_aid () {
	local signer_manifest="util/signer/ec_RW-manifest-prod.json"
	local codesigner="cr50-codesigner"

	elog "Converting prod manifest into json format"

	if ! type -P "${codesigner}" >/dev/null; then
		ewarn "${codesigner} not available, not preparing ${CR50_JSON}"
		return
	fi

	"${codesigner}" --convert-json -i "${signer_manifest}" \
			-o "${S}/${CR50_JSON}" || \
		die "failed to convert signer manifest ${signer_manifest}"
}

src_compile() {
	set_build_env

	emake clean
	emake BOARD=cr50 "${EC_OPTS[@]}"

	prepare_cr50_signer_aid

	if use fuzzer ; then
		local sanitizers=()
		use asan && sanitizers+=( 'TEST_ASAN=y' )
		use msan && sanitizers+=( 'TEST_MSAN=y' )
		use ubsan && sanitizers+=( 'TEST_UBSAN=y' )
		emake buildfuzztests "${sanitizers[@]}"
	fi
}

#
# Install additional files, necessary for Cr50 signer inputs.
#
install_cr50_signer_aid () {
	local blob

	if [[ ! -f ${S}/${CR50_JSON} ]]; then
		ewarn "Not installing Cr50 support files"
		return
	fi

	elog "Installing Cr50 signer support files"

	for blob in "${CR50_ROS[@]}"; do
		local dest_name

		# Carve out prod.ro.? from the RO blob file name. It is known
		# to follow the pattern of "*prod.ro.[AB]*".
		dest_name="${blob/*prod.ro/prod.ro}"
		newins "${DISTDIR}/${blob}" "${dest_name::9}"
	done

	doins "${S}/board/cr50/rma_key_blob".*.{prod,test}
	doins "${S}/${CR50_JSON}"
	doins "${S}/util/signer/fuses.xml"
}

src_install() {
	local build_dir
	local dest_dir

	build_dir="build/cr50"
	dest_dir='/firmware/cr50'
	einfo "Installing cr50 from ${build_dir} into ${dest_dir}"

	insinto "${dest_dir}"
	doins "${build_dir}/RW/ec.RW.elf"
	doins "${build_dir}/RW/ec.RW_B.elf"

	install_cr50_signer_aid

	if use fuzzer ; then
		local f

		insinto /usr/libexec/fuzzers
		exeinto /usr/libexec/fuzzers
		for f in build/host/*_fuzz/*_fuzz.exe; do
			local fuzzer="$(basename "${f}")"
			local custom_owners="${S}/fuzz/${fuzzer%exe}owners"
			fuzzer="ec_${fuzzer%_fuzz.exe}_fuzzer"
			newexe "${f}" "${fuzzer}"
			einfo "CUSTOM OWNERS = '${custom_owners}'"
			if [[ -f "${custom_owners}" ]]; then
				newins "${custom_owners}" "${fuzzer}.owners"
			else
				newins "${S}/OWNERS" "${fuzzer}.owners"
			fi
		done
	fi
}

