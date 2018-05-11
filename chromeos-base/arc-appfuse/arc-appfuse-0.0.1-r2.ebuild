# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

CROS_WORKON_COMMIT="f2a4feefa0a06b19fa58d18b5a04436842a406d6"
CROS_WORKON_TREE=("d62d827f7e4bd7641655640d723cb834298f7cbd" "2c5539e02d37218cda891332f5e82a69f7bea9d6")
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
