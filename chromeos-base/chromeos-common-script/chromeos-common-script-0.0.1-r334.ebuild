# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

CROS_WORKON_COMMIT="1d7ee2dfa1aff8ad039f9a3e35309c0d6b450ad3"
CROS_WORKON_TREE=("adb7e529d9a6937314eaebaf0b47b08a1c154a07" "6e637013ca230c728661cf58f7cf8271ce339711" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk chromeos-common-script .gn"

PLATFORM_SUBDIR="chromeos-common-script"

inherit cros-workon platform

DESCRIPTION="Chrome OS storage info tools"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/chromeos-common-script/"
SRC_URI=""

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE="direncryption fsverity kernel-4_4 prjquota"

REQUIRED_USE="prjquota? ( !kernel-4_4 )"

src_install() {
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
