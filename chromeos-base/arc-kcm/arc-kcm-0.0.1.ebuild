# Copyright 2019 The Chromium Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2.

EAPI=5

inherit arc-build-constants

DESCRIPTION="Generate KCM files for ARC++ from xkeyboard-config"
HOMEPAGE="http://www.chromium.org/"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
DEPEND="x11-misc/xkeyboard-config"
IUSE="cheets"
REQUIRED_USE="cheets"

# one of chromeos-base/android-container-* for XkbToKcmConverter binary.
# chromeos-base/chromeos-chrome for /usr/share/chromeos-assets/input_methods/input_methods.txt.
# x11-misc/xkeyboard-config for /usr/share/X11/xkb.
DEPEND="
	|| (
		chromeos-base/android-container-pi
		chromeos-base/android-container-qt
		chromeos-base/android-container-master-arc-dev
	)
	chromeos-base/chromeos-chrome
	x11-misc/xkeyboard-config
"

S="${WORKDIR}"

src_compile() {
	arc-build-constants-configure
	"${SYSROOT}/${ARC_ETC_DIR}/bin/XkbToKcmConverter" \
		"${SYSROOT}/usr/share/X11/xkb" \
		"${SYSROOT}/usr/share/chromeos-assets/input_methods/input_methods.txt" . || die
}

src_install() {
	insinto /usr/share/chromeos-assets/kcm
	doins -r .
}
