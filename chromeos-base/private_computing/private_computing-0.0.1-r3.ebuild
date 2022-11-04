# Copyright 2022 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="994ec7ba2c9f87ee34361e2547d7144999f3c874"
CROS_WORKON_TREE=("10e696ab6f353e2faa9fc53a5a2381a0d3f22920" "949c73de3faed1daba26b0dcf53a03f571b02837" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="private_computing common-mk .gn"

PLATFORM_SUBDIR="private_computing"

inherit cros-workon platform user

DESCRIPTION="A daemon that saves and retrieves device active status with preserved file."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/private_computing/"
LICENSE="BSD-Google"
KEYWORDS="*"

IUSE=""
COMMON_DEPEND="
	chromeos-base/minijail
	dev-libs/protobuf
"

RDEPEND="${COMMON_DEPEND}"
DEPEND="${COMMON_DEPEND}
	chromeos-base/system_api:=
	sys-apps/dbus:=
"

src_install() {
	platform_src_install
}

platform_pkg_test() {
	platform test_all
}

pkg_preinst() {
	enewuser "private_computing"
	enewgroup "private_computing"
}
