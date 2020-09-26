# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

CROS_WORKON_COMMIT="d220427c70327dc24b7251466bf1b01a6e2b29e4"
CROS_WORKON_TREE=("e878c3ec9ca8c15b6f63f45f4c95e8aaa646f0ad" "e137dc0c7282c263da7b118003b16c4ef4a97ea3" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
IUSE="direncryption fsverity"

DEPEND=""

RDEPEND="!<chromeos-base/chromeos-installer-0.0.3"

src_install() {
	insinto /usr/share/misc
	doins share/chromeos-common.sh
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
}
