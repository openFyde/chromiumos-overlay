# Copyright 2019 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="72a6100a5e48ef289f9da5212c9b6e94e8c0711b"
CROS_WORKON_TREE=("6a36baaa49726ee92adcded5d7a9c28124985e9a" "284f3602420093498b1e01984a0db1190bd55812" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
CROS_WORKON_INCREMENTAL_BUILD="1"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk libmems .gn"

PLATFORM_SUBDIR="libmems"

inherit cros-workon platform

DESCRIPTION="MEMS support library for Chromium OS."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/libmems"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE=""

COMMON_DEPEND="
	net-libs/libiio:="
RDEPEND="${COMMON_DEPEND}"
DEPEND="${COMMON_DEPEND}
	chromeos-base/system_api:="

platform_pkg_test() {
	platform test_all
}
