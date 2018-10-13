# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT="454ffd6a1dbe9453ae0bb195527c0c177de8f0f9"
CROS_WORKON_TREE=("2f1d4740f7526c3ca07c57fafce24c403436c0ad" "7c1f2e33ef1098f888557093196f37c5df056c04" "dc1506ef7c8cfd2c5ffd1809dac05596ec18773c")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk dlcservice .gn"

PLATFORM_SUBDIR="dlcservice"

inherit cros-workon platform user

DESCRIPTION="A D-Bus service for Downloadable Content (DLC)"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/dlcservice/"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE=""

RDEPEND="chromeos-base/libbrillo"

DEPEND="${RDEPEND}
	chromeos-base/system_api"

src_install() {
	dosbin "${OUT}/dlcservice"

	# Seccomp policy files.
	insinto /usr/share/policy
	newins seccomp/dlcservice-seccomp-${ARCH}.policy \
		dlcservice-seccomp.policy

	# Upstart configuration
	insinto /etc/init
	doins dlcservice.conf

	# D-Bus configuration
	insinto /etc/dbus-1/system.d
	doins org.chromium.DlcService.conf
}

platform_pkg_test() {
	platform_test "run" "${OUT}/dlcservice_tests"
}

pkg_preinst() {
	enewuser "dlcservice"
	enewgroup "dlcservice"
}
