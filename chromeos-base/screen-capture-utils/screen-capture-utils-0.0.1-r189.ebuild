# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="f35f2919309cf11b0ddd9deb24a6b145d40d9254"
CROS_WORKON_TREE=("a625767bb59509159091f2ab0b71f8b9b4b2e353" "356f1f6294b75be3dc79348a1cf68b07c023df79" "4a0dedab080195bdc122d2289118df4af3ddca2c" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
# TODO(crbug.com/809389): remove 'metrics' pulled in from header dependency.
CROS_WORKON_SUBTREE="common-mk screen-capture-utils metrics .gn"
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
	chromeos-base/metrics
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
