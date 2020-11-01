# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="7293341a35bde323e4c6daaaabb6060c86155609"
CROS_WORKON_TREE=("912515235dd01370feac9f51e1153d4684513354" "84e876973a745b98eeddbd0d1b89d32850f44fda" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_SUBTREE="common-mk screenshot .gn"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_INCREMENTAL_BUILD=1

PLATFORM_SUBDIR="screenshot"

inherit cros-workon platform

DESCRIPTION="Utility to take a screenshot"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/screenshot/"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE=""

RDEPEND="
	media-libs/libpng:0=
	media-libs/minigbm:=
	x11-libs/libdrm:=
	virtual/opengles"

DEPEND="${RDEPEND}
	x11-drivers/opengles-headers"

src_install() {
	dosbin "${OUT}/screenshot"
}
