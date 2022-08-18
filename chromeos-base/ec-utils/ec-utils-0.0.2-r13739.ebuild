# Copyright 2012 The ChromiumOS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="4958ef20368d4004df30bb54dedc210245df37a5"
CROS_WORKON_TREE="157244f8ff1f14d447a95d2f24f4ac1fa9972663"
CROS_WORKON_PROJECT="chromiumos/platform/ec"
CROS_WORKON_LOCALNAME="platform/ec"

inherit cros-workon user

DESCRIPTION="Chrome OS EC Utility"

HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/ec/"
SRC_URI=""

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="static -updater_utils"
IUSE="${IUSE} cros_host +cros_ec_utils"

COMMON_DEPEND="dev-embedded/libftdi:=
	dev-libs/openssl:0=
	sys-libs/zlib:=
	virtual/libusb:1="
DEPEND="${COMMON_DEPEND}"
RDEPEND="${COMMON_DEPEND}"

pkg_preinst() {
	enewgroup "dialout"
}

src_compile_cros_ec_utils() {
	BOARD=host emake utils-host CC="${CC}"
}

src_compile() {
	tc-export AR CC PKG_CONFIG RANLIB
	# In platform/ec Makefile, it uses "CC" to specify target chipset and
	# "HOSTCC" to compile the utility program because it assumes developers
	# want to run the utility from same host (build machine).
	# In this ebuild file, we only build utility
	# and we may want to build it so it can
	# be executed on target devices (i.e., arm/x86/amd64), not the build
	# host (BUILDCC, amd64). So we need to override HOSTCC by target "CC".
	export HOSTCC="${CC} $(usex static '-static' '')"

	# Build Chromium EC utilities.
	use cros_ec_utils && src_compile_cros_ec_utils
}

src_install_cros_ec_utils() {
	if use cros_host; then
		dobin "build/host/util/cbi-util"
	else
		dosbin "build/host/util/ectool"
		dosbin "build/host/util/ec_parse_panicinfo"
		dosbin "build/host/util/ec_sb_firmware_update"
	fi
}

src_install() {
	# Install Chromium EC utilities.
	use cros_ec_utils && src_install_cros_ec_utils
}

pkg_postinst() {
	if ! $(id -Gn "$(logname)" | grep -qw "dialout") ; then
		usermod -a -G "dialout" "$(logname)"
		einfo "A new group, dialout is added." \
			"Please re-login to apply this change."
	fi
}
