# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CROS_WORKON_COMMIT="e6bdc02b0fb28f75832c012bcadd6c826c0c6a43"
CROS_WORKON_TREE=("1a4b7a7926e6533605c6bf09c5726f6d18045350" "5ecefa8246d0b6402947dff54f84a5745c1bc38f" "dc1506ef7c8cfd2c5ffd1809dac05596ec18773c")
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
