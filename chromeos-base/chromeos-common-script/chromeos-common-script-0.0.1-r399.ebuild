# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

CROS_WORKON_COMMIT="f248db1f0fc22cac2345bc128a6a0a3276c7c430"
CROS_WORKON_TREE=("0db6495c85c9186f120853ea040436bf4259ef96" "777454ed89f9fb3a7f25a3f844449983a1f6c3fa" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
