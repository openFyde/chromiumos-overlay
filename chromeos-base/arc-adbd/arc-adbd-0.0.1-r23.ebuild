# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

CROS_WORKON_COMMIT="207b9c95e801b90f6616962cb928bec371aed39f"
CROS_WORKON_TREE=("17f4a6efa079886fb3e23fd256264f932d59721d" "02e9fe71945dbd6fcb3bcaa7eee72ac847c2167c")
CROS_WORKON_INCREMENTAL_BUILD="1"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk arc/adbd"

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
