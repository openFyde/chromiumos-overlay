# Copyright 2018 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

CROS_WORKON_COMMIT="f5905cb27d9b5dbf6bf6e338cf012ba9267a0523"
CROS_WORKON_TREE=("4d05be6aacce39f0ffed0cb00fc7d88926121b65" "2fcd29ec32d574dde34225eb5a81aedf9aca3d5e" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk chromeos-common-script .gn"

PLATFORM_SUBDIR="chromeos-common-script"

inherit cros-workon platform

DESCRIPTION="Chrome OS storage info tools"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/chromeos-common-script/"
SRC_URI=""

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE="direncryption fsverity kernel-4_4 prjquota"

REQUIRED_USE="prjquota? ( !kernel-4_4 )"

src_install() {
	platform_src_install

	insinto /usr/share/misc
	doins share/chromeos-common.sh
	doins share/lvm-utils.sh
	if use direncryption; then
		sed -i '/local direncryption_enabled=/s/false/true/' \
			"${D}/usr/share/misc/chromeos-common.sh" ||
			die "Can not set directory encryption in common library"
	fi
	if use fsverity; then
		sed -i '/local fsverity_enabled=/s/false/true/' \
			"${D}/usr/share/misc/chromeos-common.sh" ||
			die "Can not set fs-verity in common library"
	fi
	if use prjquota; then
		sed -i '/local prjquota_enabled=/s/false/true/' \
			"${D}/usr/share/misc/chromeos-common.sh" ||
			die "Can not set project quota in common library"
	fi
}
