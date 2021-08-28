# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="873ff642e711a36591cd30344d13a58f40eb1e4c"
CROS_WORKON_TREE=("a3d79a5641e6cda7da95a9316f5d29998cc84865" "b69483fb422e7e995ede55564ab82bdc405328a8" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "2e70595826ad86b826c299379e82987a3061dc9b")
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
