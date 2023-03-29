# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="2d89f7432d8f231a7ccf957cb4bc3bce73e9d9e4"
CROS_WORKON_TREE=("952d2f368a90cdfa98da94394d2a56079cef3597" "8e8778e3d2da731170cfedad592275b128997691" "6e2537c05135db7b7a85da8c801a540c889ce4a0" "22d5274d1e7570d1be474dd10560ef20113f4d3c" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
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
