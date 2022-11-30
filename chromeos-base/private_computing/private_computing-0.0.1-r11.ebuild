# Copyright 2022 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="ea0be997183dd1da255b09be1ee0d6c8178de72a"
CROS_WORKON_TREE=("85ecc03de9c77a2f0c7f0ddd411efcf660613080" "7c7d4170b01f9cd05a107c251a378c716ccd9d77" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
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
