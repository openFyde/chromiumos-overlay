# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="da3a7bc1d0bc06a3bfc02e7f21e3a9f5e10d58bf"
CROS_WORKON_TREE=("0c4b88db0ba1152616515efb0c6660853232e8d0" "cfc7ccc022decdd9f2e3881bc2b88c4fb71f33cf" "df143cde88af1b7e2427d71c8519156768a0ef36" "9da4303fca3d31774ff2a0ed56ad7e4beb63abc7" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
CROS_WORKON_INCREMENTAL_BUILD="1"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk discod libhwsec-foundation metrics .gn"

PLATFORM_SUBDIR="discod"

inherit cros-workon platform user

DESCRIPTION="Disk Control daemon for ChromiumOS"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/discod/"
LICENSE="BSD-Google"
KEYWORDS="*"
IUSE=""

COMMON_DEPEND="
	chromeos-base/libhwsec-foundation:=
	chromeos-base/metrics:=
	sys-apps/rootdev:=
"

RDEPEND="${COMMON_DEPEND}"

DEPEND="
	${COMMON_DEPEND}
	chromeos-base/system_api:=
"

pkg_preinst() {
	enewuser "disco"
	enewgroup "disco"
}

platform_pkg_test() {
	platform test_all
}
