# Copyright 2015 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT="13938c4e61449924954f5c1bc02a404d787d3cdf"
CROS_WORKON_TREE=("101900c2b48b3a1e97069bd81150e6af6ff9e680" "ea18bb4b1c7915e8b0724cc48e1c0c9dd68e3de7" "dc1506ef7c8cfd2c5ffd1809dac05596ec18773c")
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="../platform2"
CROS_WORKON_DESTDIR="${S}"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk fitpicker .gn"

PLATFORM_SUBDIR="fitpicker"

inherit cros-workon platform

DESCRIPTION="Utility for picking a kernel/device tree from a FIT image."
HOMEPAGE="http://www.chromium.org/"
SRC_URI=""

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"

RDEPEND=">=sys-apps/dtc-1.4.1"
DEPEND="${RDEPEND}"

src_install() {
	dobin "${OUT}"/fitpicker
}
