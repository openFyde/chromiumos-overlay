# Copyright 2020 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT=("9598ed0cf322a3865536a3ba7290dd19e8ae519a" "5e9a89d06c41edf5cf43da8acf5f26ed104887e6")
CROS_WORKON_TREE=("f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6" "b299a1a5ae7da8f6d60cacda4066d77fbe5c86e4" "284f3602420093498b1e01984a0db1190bd55812" "ebcce78502266e81f55c63ade8f25b8888e2c103" "db75597a3a702c90030f8f50dee1f1f79046be1a" "a7ce08df7abdb46c261c18e816349ff5afc30194" "693bb2d63562c6eff050d04f75aab1e9251e6548")
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

platform_pkg_test() {
	platform test_all
}
