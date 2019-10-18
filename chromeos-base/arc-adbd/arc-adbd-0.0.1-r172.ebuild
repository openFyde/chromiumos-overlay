# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

CROS_WORKON_COMMIT="643d14161a331f25c913bc5de521eb4bde7812c9"
CROS_WORKON_TREE=("96ecb2dad8cd853305974b8e506a17e386c4ee60" "daa7c74c9797b5771f44668bd240bc2496146887" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD="1"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk arc/adbd .gn"

PLATFORM_SUBDIR="arc/adbd"

inherit cros-workon platform

DESCRIPTION="Container to run Android's adbd proxy."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/arc/adbd"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE="+seccomp fuzzer"

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

	# Install fuzzer.
	platform_fuzzer_install "${S}"/OWNERS "${OUT}"/arc-adbd-setup-config-fs-fuzzer
	platform_fuzzer_install "${S}"/OWNERS "${OUT}"/arc-adbd-setup-function-fs-fuzzer
}
