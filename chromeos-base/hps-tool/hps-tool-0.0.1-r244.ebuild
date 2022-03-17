# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="fb19b4c7c8125ba2a56c76650664de3d943fa603"
CROS_WORKON_TREE=("38a9b1daf75f7eb99a4e2bce2be48157069e9a15" "72ad526cf92e8bf7ec7552cc703c6baa90b98d24" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "252d446a8eff95d46efbaa67556405056abf432a")
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
	chromeos-base/metrics:=
	virtual/libusb:1
	"

RDEPEND="${COMMON_DEPEND}"

DEPEND="${COMMON_DEPEND}"

src_install() {
	platform_src_install

	dobin "${OUT}"/hps
}
