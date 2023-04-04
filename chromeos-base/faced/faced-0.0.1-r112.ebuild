# Copyright 2022 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_WORKON_COMMIT="53976e946ff67846962c80391d3946561c7f14d1"
CROS_WORKON_TREE=("5b87e97f3ddb9634fb1d975839c28e49503e94f8" "57aadae08473997802cb0f54355f2324c214910c" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
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
