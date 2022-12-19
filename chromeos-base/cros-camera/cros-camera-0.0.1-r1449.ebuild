# Copyright 2017 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="a03cc84f987e4ae46540c1504e642c1db9ab8c98"
CROS_WORKON_TREE=("f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6" "2ad8679ea3a8f3e8a2509b4b05585f22f2dc373b" "fb991ada697f993a8282997d62671c49daef274f" "be3889ade895715816396f918ac139d1cc944c3f" "25c0e94cb9e00d546d5f2b4e22ba5efe4b6306f5" "f0a2de010874ab6cbc46ffd7b5adb4b462bfff70" "b0c589f095672e09888fb79820c8fbae302ec210" "7e58eaa2e768ae8112ab3b362a1d789a1f73e78e" "a0af00390c3d3c63903578edd1d7c7cb504a8699" "0c3a30cd50ce72094fbd880f2d16d449139646a2" "852e3fb47c6c7bc3baf28d7cb71766ea4aeee96e")
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
	dobin "${OUT}/cros_camera_service"

	insinto /etc/init
	doins init/cros-camera.conf
	doins init/cros-camera-failsafe.conf

	insinto /etc/dbus-1/system.d
	doins dbus/CrosCamera.conf

	udev_dorules udev/99-camera.rules

	# Install seccomp policy file.
	insinto /usr/share/policy
	newins "seccomp_filter/cros-camera-${ARCH}.policy" cros-camera.policy

	dotmpfiles tmpfiles.d/*.conf

	if use cheets && ! use arc-camera1; then
		insinto "${ARC_VENDOR_DIR}/etc/init"
		doins init/init.camera.rc
	fi
}

pkg_preinst() {
	enewuser "arc-camera"
	enewgroup "arc-camera"
}
