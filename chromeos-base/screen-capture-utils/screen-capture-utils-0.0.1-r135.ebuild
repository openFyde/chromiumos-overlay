# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="91d24f3a2ab509418bcca3e174a3b779744f0afa"
CROS_WORKON_TREE=("f9c9ff0f07a0e5d4015af871a558204de304bb90" "13b981873aeeddde042e6acfa4cd3a89e878984e" "e849dc63a297841f850ba099695224eea2cd48af" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
