# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="02a4cc7fd42e443b63d1ef92546ee35dd47d1d0e"
CROS_WORKON_TREE=("cdef43f78358fd6a09f7c99f0f24b233fa2c1ad7" "d55943002ae06877156d158a78ac307a26dc25c2" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
