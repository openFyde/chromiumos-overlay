# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

CROS_WORKON_COMMIT="09ff35bf0115fd53b6b0ac834dd724bd0ccca3dd"
CROS_WORKON_TREE=("4339564d7670b48f93256d3a28a1e4bcb2d4317b" "691d897ac8d6b2b6de4cfcb54f02717be9ac4684")
CROS_WORKON_INCREMENTAL_BUILD="1"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk arc/appfuse"

PLATFORM_SUBDIR="arc/appfuse"
PLATFORM_GYP_FILE="appfuse.gyp"

inherit cros-workon platform

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

platform_pkg_test() {
	platform_test "run" "${OUT}/arc-appfuse_testrunner"
}
