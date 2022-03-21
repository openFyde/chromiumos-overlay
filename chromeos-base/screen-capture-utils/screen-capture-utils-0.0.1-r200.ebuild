# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="378450bea9f1374e98d1e597b1aa65fff5384837"
CROS_WORKON_TREE=("4a5014026787ab30d197b30eb40d6b4359a0ee09" "1426d6ed0d4845aa05942d11fe6ec8b60160a353" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_SUBTREE="common-mk screen-capture-utils .gn"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_INCREMENTAL_BUILD=1

PLATFORM_SUBDIR="screen-capture-utils"

inherit cros-workon platform

DESCRIPTION="Utilities for screen capturing"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/screen-capture-utils/"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE=""

# Mark the old screenshot package as blocker so it gets automatically removed in
# incremental builds.
RDEPEND="
	!chromeos-base/screenshot
	media-libs/libpng:0=
	media-libs/minigbm:=
	net-libs/libvncserver
	x11-libs/libdrm:=
	virtual/opengles"

DEPEND="${RDEPEND}
	x11-drivers/opengles-headers"

src_install() {
	platform_install

	# Component: ARC++ > Eng Velocity.
	local fuzzer_component_id="515942"
	platform_fuzzer_install "${S}"/OWNERS "${OUT}"/screen-capture_png_fuzzer \
		--comp "${fuzzer_component_id}"
}

platform_pkg_test() {
	platform test_all
}
