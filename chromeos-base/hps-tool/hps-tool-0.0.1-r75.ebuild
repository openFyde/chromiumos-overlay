# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="f13d8789b11ab3d0d8e4064e0dd4b6cfa510d212"
CROS_WORKON_TREE=("6b82b37113f6969a6645e19dabaeda0cb4e502d5" "9e6883ffbcc4ff015a20a7e1e1fddf4d5e75d2f6" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "5666fc7e1ee7a8464bf7740216c02b8d117a7461")
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_SUBTREE="common-mk hps .gn metrics"

PLATFORM_SUBDIR="hps/util"

inherit cros-workon platform

DESCRIPTION="HPS utilities and tool"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/main/hps"

LICENSE="BSD-Google"
SLOT="0/0"
KEYWORDS="*"

COMMON_DEPEND="
	dev-libs/libusb:=
	dev-embedded/libftdi:=
	chromeos-base/metrics:=
	"

RDEPEND="${COMMON_DEPEND}"

DEPEND="
	${COMMON_DEPEND}
	"

src_install() {
	dobin "${OUT}"/hps
}
