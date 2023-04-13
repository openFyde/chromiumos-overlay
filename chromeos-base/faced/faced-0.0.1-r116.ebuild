# Copyright 2022 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_WORKON_COMMIT="cbba8c413a1cae7db84ea0dcd910b4f4a01ce167"
CROS_WORKON_TREE=("b9c8b8315a832ea4cfd3cb10367bc58e9a3ecb2a" "3c089fdbaa6d28bc95fce8ccd338d92184a19cb3" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
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
