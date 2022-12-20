# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="2024c47f3cea15401fe53a34e6140993777bcbcb"
CROS_WORKON_TREE=("0c3a30cd50ce72094fbd880f2d16d449139646a2" "cfc7ccc022decdd9f2e3881bc2b88c4fb71f33cf" "df143cde88af1b7e2427d71c8519156768a0ef36" "8d856cb1fd8b7169075c5ae9c9a1ed9d4b8cbd6b" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
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
