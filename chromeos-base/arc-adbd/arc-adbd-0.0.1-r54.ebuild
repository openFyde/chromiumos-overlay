# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

CROS_WORKON_COMMIT="5f27649cb24a11fd887c61ab61df275b6a702587"
CROS_WORKON_TREE=("56c75aa73108d344f9441f26855f37e4c4838dd3" "cad18881d5786180d876615d1d5c2f07ee9fadf0" "dc1506ef7c8cfd2c5ffd1809dac05596ec18773c")
CROS_WORKON_INCREMENTAL_BUILD="1"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk arc/adbd .gn"

PLATFORM_SUBDIR="arc/adbd"
PLATFORM_GYP_FILE="adbd.gyp"

inherit cros-workon platform

DESCRIPTION="Container to run Android's adbd proxy."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/arc/adbd"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE="+seccomp"

RDEPEND="
	chromeos-base/libbrillo
	chromeos-base/minijail
"

src_install() {
	insinto /etc/init
	doins init/arc-adbd.conf

	insinto /usr/share/policy
	use seccomp && newins "seccomp/arc-adbd-${ARCH}.policy" arc-adbd-seccomp.policy

	dosbin "${OUT}/arc-adbd"
}
