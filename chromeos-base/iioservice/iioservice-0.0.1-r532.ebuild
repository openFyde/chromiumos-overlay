# Copyright 2020 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT=("55478e56ce3eed1f7c2651bd06f3b7142f582a4d" "5e9a89d06c41edf5cf43da8acf5f26ed104887e6")
CROS_WORKON_TREE=("f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6" "4d13cefb4b4fcb8f643fb162b2b14867a0d884f0" "9edcaccb998f9f1dac82dd862beddc2491e8ab68" "3f8a9a04e17758df936e248583cfb92fc484e24c" "e1f223c8511c80222f764c8768942936a8de01e4" "73889d0041bcd8e88b0b6d54e8d40eb99eaac094" "693bb2d63562c6eff050d04f75aab1e9251e6548")
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
