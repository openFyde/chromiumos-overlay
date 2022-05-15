# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="9a1103a9ac9e7b90a39bcb949992fe5dac074aee"
CROS_WORKON_TREE=("f7122dee369efc8a9c0fff9f33ad43b0ae9a9aef" "91a270072b83432192d094249cada40554b6056b" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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

src_install() {
	platform_install
}

platform_pkg_test() {
	platform test_all
}
