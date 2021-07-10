# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="ac131b5b434a487e5e924a07929fed0ad88094c3"
CROS_WORKON_TREE=("d5666e714c30f8f7921e63e91f60431992f31333" "dff428784a910a64f792e769916f70d39ac7406a" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD="1"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="arc/adbd common-mk .gn"

PLATFORM_SUBDIR="arc/adbd"

inherit cros-workon platform

DESCRIPTION="Container to run Android's adbd proxy."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/arc/adbd"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="+seccomp fuzzer arcvm"

RDEPEND="
	chromeos-base/minijail
"

src_install() {
	insinto /etc/init
	if use arcvm; then
		doins init/arcvm-adbd.conf
		insinto /etc/dbus-1/system.d
		doins init/dbus-1/ArcVmAdbd.conf
	else
		doins init/arc-adbd.conf
	fi

	insinto /usr/share/policy
	use seccomp && newins "seccomp/arc$(usex arcvm vm '')-adbd-${ARCH}.policy" "arc$(usex arcvm vm '')-adbd-seccomp.policy"

	dosbin "${OUT}/arc-adbd"

	# Install fuzzers.
	platform_fuzzer_install "${S}"/OWNERS "${OUT}"/arc-adbd-setup-config-fs-fuzzer
	platform_fuzzer_install "${S}"/OWNERS "${OUT}"/arc-adbd-setup-function-fs-fuzzer
	platform_fuzzer_install "${S}"/OWNERS "${OUT}"/arc-adbd-create-pipe-fuzzer
}
