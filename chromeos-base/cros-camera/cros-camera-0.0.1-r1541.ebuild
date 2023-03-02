# Copyright 2017 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="5e015c51961dd6785f65516a350885927932e69a"
CROS_WORKON_TREE=("f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6" "2ad8679ea3a8f3e8a2509b4b05585f22f2dc373b" "28e32d194b1e6c52d53446c04e8036414b2c8e12" "1ea58e313616fd1f2d2a4ce39037869dfb136a1c" "f350915f69eba67849197cce3901bc104da7121a" "7303e8b20997fb4181d69e19bf8a48adb02144c9" "1e6e8d2b2310e2578fe134c24981bdf60788ffde" "2a732d74405761e6ffe5bcc97cbcd79de8741778" "2ae3f5c18c4a966b50d7defcd4e5ecfc5d40d1d9" "0f4044624c1fabe638a8289e62ec74756aa62176" "e7b277c902521ebce99b342283d0aa3f9ce48ac0")
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="platform2"
# TODO(crbug.com/914263): camera/hal is unnecessary for this build but is
# workaround for unexpected sandbox behavior.
CROS_WORKON_SUBTREE=".gn camera/build camera/common camera/features camera/gpu camera/hal camera/hal_adapter camera/include camera/mojo common-mk ml_core"
CROS_WORKON_OUTOFTREE_BUILD="1"
CROS_WORKON_INCREMENTAL_BUILD="1"

PLATFORM_SUBDIR="camera/hal_adapter"

inherit cros-camera cros-constants cros-workon platform tmpfiles user udev

DESCRIPTION="Chrome OS camera service. The service is in charge of accessing
camera device. It uses unix domain socket to build a synchronous channel."

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="arc-camera1 cheets camera_feature_face_detection -libcamera"

BDEPEND="virtual/pkgconfig"

RDEPEND="
	>=chromeos-base/cros-camera-libs-0.0.1-r34:=
	chromeos-base/cros-camera-android-deps:=
	media-libs/cros-camera-hal-usb:=
	media-libs/libsync:=
	libcamera? ( media-libs/libcamera )
	!libcamera? (
		virtual/cros-camera-hal
		virtual/cros-camera-hal-configs
	)"

DEPEND="${RDEPEND}
	chromeos-base/dlcservice-client:=
	>=chromeos-base/metrics-0.0.1-r3152:=
	media-libs/minigbm:=
	x11-libs/libdrm:="

src_configure() {
	cros_optimize_package_for_speed
	platform_src_configure
}

src_install() {
	platform_src_install
	udev_dorules udev/99-camera.rules
	dotmpfiles tmpfiles.d/*.conf
}

pkg_preinst() {
	enewuser "arc-camera"
	enewgroup "arc-camera"
	enewgroup "camera"
}
