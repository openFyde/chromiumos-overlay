# Copyright 2022 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="3029dee1d1fb9cb7ee8e092de98df2df12f5e60e"
CROS_WORKON_TREE=("6290ba0b1f5cd85cff00890ec6c98af0de1fb851" "6836462cc3ac7e9ff3ce4e355c68c389eb402bff" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="private_computing common-mk .gn"

PLATFORM_SUBDIR="private_computing"

inherit cros-workon platform user tmpfiles

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
	dotmpfiles tmpfiles.d/private_computing.conf
}

platform_pkg_test() {
	platform test_all
}

pkg_preinst() {
	enewuser "private_computing"
	enewgroup "private_computing"
}
