# Copyright 2020 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT=("1dffef3b5fa35642ed3ad2b54aa7554bf0d3ed60" "5e9a89d06c41edf5cf43da8acf5f26ed104887e6")
CROS_WORKON_TREE=("f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6" "8070503238b744a2c1b99b738565dfd0027b08e2" "284f3602420093498b1e01984a0db1190bd55812" "52639708fb7bf1a26ac114df488dc561a7ca9f3c" "e62146994a05b9efea89b0e552f15189de3f8dfd" "e79f0903db5555c62d20b930626f93acc7d7b070" "693bb2d63562c6eff050d04f75aab1e9251e6548")
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
CROS_WORKON_SUBTREE=(".gn iioservice libmems common-mk metrics mojo_service_manager" "")
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
	chromeos-base/mojo_service_manager:=
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
