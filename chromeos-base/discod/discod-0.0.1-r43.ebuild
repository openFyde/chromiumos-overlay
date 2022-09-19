# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="368b76f5c0e56a04f4802e8f20a2c5b8c711886a"
CROS_WORKON_TREE=("52639708fb7bf1a26ac114df488dc561a7ca9f3c" "c98e9d50646cce2059da44dcde760c319983f5f6" "d1d7e3ee195fa8851737c7be406928e3da6fedd0" "eb510d666a66e6125e281499b649651b849a25f7" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
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

src_install() {
	platform_install
}

platform_pkg_test() {
	platform test_all
}
