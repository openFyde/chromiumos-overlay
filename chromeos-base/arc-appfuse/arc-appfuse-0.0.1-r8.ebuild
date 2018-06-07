# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

CROS_WORKON_COMMIT="a98cb102e16995c8ad3a630e66fd238575b4af06"
CROS_WORKON_TREE=("7f3772ca0f71f93049a5823095bfa3f5620f016f" "d074c13a7f4526c33afe9e99270a6b8dd0c1ff0a")
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

	# TODO(hashimoto): Add an upstart conf file to start this service in
	# minijail when ARC starts.
}

platform_pkg_test() {
	platform_test "run" "${OUT}/arc-appfuse_testrunner"
}
