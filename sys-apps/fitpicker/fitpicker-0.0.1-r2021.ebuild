# Copyright 2015 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT="86bcf17f5d3fce2ea2e6f4d21ef7ca3b5a393ed2"
CROS_WORKON_TREE=("2b7b46ab1083cdcc8b17bd7f5b05ddff336b0559" "8a70db12c3bdef6070bda5102927e50d23632e94" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
