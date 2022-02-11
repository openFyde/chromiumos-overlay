# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT=("ce108d53b02735496c481b16dbb996b061fa03ea" "8300206169b81cf8f6600886bc1f5a86e62ace98")
CROS_WORKON_TREE=("e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "0c76cb6e39afbd414c2a7bf0d759af9e678deeeb" "929473dc551da68ad25453a477c95767c65e9e22" "2f8a3fd5e0af952f605c8e7b8afa1ecedad683fa" "7bd2393837bc4162899abba0a3c6977b462df042" "7b1902bfd171c628068c91fc41e253d0c08df363")
inherit cros-constants

CROS_WORKON_PROJECT=(
	"chromiumos/platform2"
	"aosp/platform/frameworks/native"
)
CROS_WORKON_LOCALNAME=(
	"platform2"
	"aosp/frameworks/native"
)
CROS_WORKON_REPO=(
	"${CROS_GIT_HOST_URL}"
	"${CROS_GIT_HOST_URL}"
)
CROS_WORKON_DESTDIR=(
	"${S}/platform2"
	"${S}/platform2/aosp/frameworks/native"
)
CROS_WORKON_EGIT_BRANCH=(
	"main"
	"master"
)
# TODO(crbug.com/809389): Remove libmems from this list.
CROS_WORKON_SUBTREE=(".gn iioservice libmems common-mk metrics" "")
CROS_WORKON_INCREMENTAL_BUILD="1"

PLATFORM_SUBDIR="iioservice/daemon"

inherit cros-workon platform user

DESCRIPTION="Chrome OS sensor HAL IPC util."

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="+seccomp"

RDEPEND="
	!chromeos-base/chromeos-accelerometer-init
	>=chromeos-base/metrics-0.0.1-r3152:=
	chromeos-base/libiioservice_ipc:=
	chromeos-base/libmems:=
	chromeos-base/mems_setup
	virtual/chromeos-ec-driver-init
"

DEPEND="${RDEPEND}
	chromeos-base/system_api:=
"

pkg_preinst() {
	enewuser "iioservice"
	enewgroup "iioservice"
}

src_install() {
	platform_install
}

platform_pkg_test() {
	platform test_all
}
