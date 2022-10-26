# Copyright 2022 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_WORKON_COMMIT="8e27f8da3b5877ffdc91ade834cb3bfbc0dea7b8"
CROS_WORKON_TREE=("bb46f20bc6d2f9e7fb1aa1178d1e47384440de9a" "edb8c5425087c461953ce7dd026df3f1ab7aebaf" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk faced .gn"

PLATFORM_NATIVE_TEST="yes"
PLATFORM_SUBDIR="faced"

inherit cros-workon platform user

DESCRIPTION="Face authentication Daemon for Chromium OS"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/faced/README.md"
LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="
"

COMMON_DEPEND="
	dev-cpp/abseil-cpp:=
	chromeos-base/cros-camera-libs:=
"

RDEPEND="
	${COMMON_DEPEND}
"

DEPEND="
	${COMMON_DEPEND}
	chromeos-base/system_api:=
"

pkg_setup() {
	# Create the "faced" user and group in pkg_setup instead of pkg_preinst
	# in order to mount cryptohome daemon store
	enewuser "faced"
	enewgroup "faced"
	cros-workon_pkg_setup
}

src_install() {
	platform_src_install

	# Set up cryptohome daemon mount store in daemon's mount
	# namespace.
	local daemon_store="/etc/daemon-store/faced"
	dodir "${daemon_store}"
	fperms 0700 "${daemon_store}"
	fowners faced:faced "${daemon_store}"
}

platform_pkg_test() {
	platform test_all
}
