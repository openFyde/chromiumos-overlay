# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CROS_WORKON_COMMIT="5ca6c3a1f7eaa42c77f7d222f3c44791e2dd650b"
CROS_WORKON_TREE=("7c2672e7fd88678931ee5c3ebbcc5e20699264c1" "5ecefa8246d0b6402947dff54f84a5745c1bc38f" "dc1506ef7c8cfd2c5ffd1809dac05596ec18773c")
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
SLOT="0"
KEYWORDS="*"
IUSE=""

RDEPEND="
	media-libs/libpng:0=
	media-libs/minigbm
	x11-libs/libdrm"

DEPEND="${RDEPEND}"

src_install() {
	dosbin "${OUT}/screenshot"
}
