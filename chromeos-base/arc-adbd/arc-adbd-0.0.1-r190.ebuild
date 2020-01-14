# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="26ec26c4ac3ba35bf59fa5acbbd26c59a3381adc"
CROS_WORKON_TREE=("65558ff6a3b26d0ace511c80691b2d4c133fa71b" "0b924299955effa78df003f971bf45060635b2cd" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
KEYWORDS="*"
IUSE="+seccomp fuzzer"

RDEPEND="
	chromeos-base/minijail
"

src_install() {
	insinto /etc/init
	doins init/arc-adbd.conf

	insinto /usr/share/policy
	use seccomp && newins "seccomp/arc-adbd-${ARCH}.policy" arc-adbd-seccomp.policy

	dosbin "${OUT}/arc-adbd"

	# Install fuzzers.
	platform_fuzzer_install "${S}"/OWNERS "${OUT}"/arc-adbd-setup-config-fs-fuzzer
	platform_fuzzer_install "${S}"/OWNERS "${OUT}"/arc-adbd-setup-function-fs-fuzzer
	platform_fuzzer_install "${S}"/OWNERS "${OUT}"/arc-adbd-create-pipe-fuzzer
}
