# Copyright 2019 The Chromium Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2.

EAPI=5

inherit cros-constants

DESCRIPTION="Generate KCM files for ARC++ from xkeyboard-config"
HOMEPAGE="http://www.chromium.org/"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE="
	android-container-pi
	android-container-qt
	android-container-master-arc-dev
"

REQUIRED_USE="^^ ( android-container-pi android-container-qt android-container-master-arc-dev )"

DEPEND="
	android-container-pi? ( chromeos-base/android-container-pi )
	android-container-qt? ( chromeos-base/android-container-qt )
	android-container-master-arc-dev? ( chromeos-base/android-container-master-arc-dev )
	chromeos-base/chromeos-chrome
	x11-misc/xkeyboard-config
"

S="${WORKDIR}"

src_compile() {
	"${SYSROOT}/${ARC_ETC_DIR}/bin/XkbToKcmConverter" \
		"${SYSROOT}/usr/share/X11/xkb" \
		"${SYSROOT}/usr/share/chromeos-assets/input_methods/input_methods.txt" . || die
}

src_install() {
	insinto /usr/share/chromeos-assets/kcm
	doins -r .
}
