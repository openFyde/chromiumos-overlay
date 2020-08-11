# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="1b0faf565c66af50e4546cf58365b5a2396add57"
CROS_WORKON_TREE=("61c2d3b995cb2496bdb185070e9e4586895f00e8" "0d8ac1008cbdcffb0b0403ed8c647c8a5084336a" "f30d511519e90855df4ace6e454d50e27789921c" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD="1"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="arc/adbd common-mk patchpanel .gn"

PLATFORM_SUBDIR="arc/adbd"

inherit cros-workon platform

DESCRIPTION="Container to run Android's adbd proxy."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/arc/adbd"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="+seccomp fuzzer arcvm"

VM_DEPEND="
	chromeos-base/patchpanel
"

VM_RDEPEND=${VM_DEPEND}

DEPEND="
	arcvm? ( ${VM_DEPEND} )
"

RDEPEND="
	arcvm? ( ${VM_RDEPEND} )
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
