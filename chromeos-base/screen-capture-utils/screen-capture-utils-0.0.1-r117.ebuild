# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="05f52a263e7aeafbf90a1dab8917a227f43f7840"
CROS_WORKON_TREE=("9f4c41ee6c8d3df72cc35bf4a0b4fe2d862591fa" "8b89a9d0f47830aee3f4a77fbbc79490c1495812" "05925a6b283684f09bb648e1a5d8ad431f3a667a" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
	dosbin "${OUT}/kmsvnc"
	dosbin "${OUT}/screenshot"
}

platform_pkg_test() {
	platform test_all
}
