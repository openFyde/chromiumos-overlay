# Copyright 2015 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="0a5793abb36ca159efbc84a0a4aa1d566cbf1106"
CROS_WORKON_TREE="87e39cb12ae271131e61ca6d7500222f2cba380b"
CROS_WORKON_PROJECT="chromiumos/third_party/tpm2"
CROS_WORKON_LOCALNAME="third_party/tpm2"

inherit cros-workon toolchain-funcs

DESCRIPTION="TPM2.0 library"
HOMEPAGE="http://www.chromium.org/"

LICENSE="BSD-Google"
KEYWORDS="*"

DEPEND="dev-libs/openssl:0="

src_compile() {
	tc-export CC AR RANLIB
	emake
}

src_install() {
	dolib.a build/libtpm2.a

	"${S}"/thirdparty_preinstall.sh "${PV}" "$(cros-workon_get_build_dir)"
	insinto "/usr/$(get_libdir)/pkgconfig"
	doins "$(cros-workon_get_build_dir)/libtpm2.pc"

	insinto /usr/include/tpm2
	doins BaseTypes.h
	doins Capabilities.h
	doins ExecCommand_fp.h
	doins GetCommandCodeString_fp.h
	doins Implementation.h
	doins Manufacture_fp.h
	doins Platform.h
	doins TPMB.h
	doins TPM_Types.h
	doins Tpm.h
	doins TpmBuildSwitches.h
	doins TpmError.h
	doins _TPM_Init_fp.h
	doins bool.h
	doins swap.h
	doins tpm_generated.h
	doins tpm_types.h
}
