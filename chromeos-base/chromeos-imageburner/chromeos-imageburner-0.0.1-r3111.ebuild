# Copyright (c) 2010 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="5"
CROS_WORKON_COMMIT="53eb7dac34bd189fa74f7e18f11a939bdfd33a27"
CROS_WORKON_TREE=("a58d199d2c4d0e5da40bb5d453f513f5e2c97ae4" "7568d3e8e81e913fe18ef6a91405fc52e3d1e2b1" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk image-burner .gn"

PLATFORM_NATIVE_TEST="yes"
PLATFORM_SUBDIR="image-burner"

inherit cros-workon platform

DESCRIPTION="Image-burning service for Chromium OS"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/image-burner/"
SRC_URI=""

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE=""

RDEPEND="
	dev-libs/dbus-glib
	dev-libs/glib
	sys-apps/rootdev
"
DEPEND="${RDEPEND}
	chromeos-base/system_api
"

src_install() {
	dosbin "${OUT}"/image_burner

	insinto /etc/dbus-1/system.d
	doins ImageBurner.conf

	insinto /usr/share/dbus-1/system-services
	doins org.chromium.ImageBurner.service

	insinto /etc/init
	doins init/image-burner.conf
}

platform_pkg_test() {
	platform_test "run" "${OUT}/unittest_runner"
}
