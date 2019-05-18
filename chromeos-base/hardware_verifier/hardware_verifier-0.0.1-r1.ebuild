# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CROS_WORKON_COMMIT="07b8f0f587829c387f00d429211ed95014aa9c95"
CROS_WORKON_TREE=("5e2f6a416f94eb6dd70589e548bbeac32fbf7c13" "8f858e0eaf9bd1e21836394a2b7dcccd12808b8d" "dc1506ef7c8cfd2c5ffd1809dac05596ec18773c")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk hardware_verifier .gn"

PLATFORM_SUBDIR="hardware_verifier"

inherit cros-workon platform

DESCRIPTION="Hardware Verifier Tool/Lib for Chrome OS"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/hardware_verifier/"

LICENSE="BSD-Google"
SLOT=0
KEYWORDS="*"

RDEPEND="
	chromeos-base/libbrillo:=
"
DEPEND="
	${RDEPEND}
	chromeos-base/system_api
	chromeos-base/vboot_reference
"

src_install() {
	# TODO(yhong): Install the bin file to the rootfs when it's ready.
	return
}

platform_pkg_test() {
	platform_test "run" "${OUT}/unittest_runner"
}
