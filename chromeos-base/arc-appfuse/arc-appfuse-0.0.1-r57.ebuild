# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

CROS_WORKON_COMMIT="04211c61ef8d1f9d680ee9db5b30ad0855f4b99e"
CROS_WORKON_TREE=("30d49e96f78c127c17008bafed2c41d759f8abe8" "c846a49361f33023dc6c95171d274ce3a1c0331d" "dc1506ef7c8cfd2c5ffd1809dac05596ec18773c")
CROS_WORKON_INCREMENTAL_BUILD="1"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk arc/appfuse .gn"

PLATFORM_SUBDIR="arc/appfuse"
PLATFORM_GYP_FILE="appfuse.gyp"

inherit cros-workon platform user

DESCRIPTION="D-Bus service to provide ARC Appfuse"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/arc/appfuse"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"

RDEPEND="
	chromeos-base/libbrillo
	sys-apps/dbus
	sys-fs/fuse
"

DEPEND="${RDEPEND}
	chromeos-base/system_api
	virtual/pkgconfig"

src_install() {
	dobin "${OUT}/arc-appfuse-provider"

	insinto /etc/dbus-1/system.d
	doins org.chromium.ArcAppfuseProvider.conf

	insinto /etc/init
	doins init/arc-appfuse-provider.conf

	insinto /usr/share/policy
	newins "seccomp/arc-appfuse-provider-seccomp-${ARCH}.policy" arc-appfuse-provider-seccomp.policy
}

pkg_preinst() {
	enewuser "arc-appfuse-provider"
	enewgroup "arc-appfuse-provider"
}

platform_pkg_test() {
	platform_test "run" "${OUT}/arc-appfuse_testrunner"
}
