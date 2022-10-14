# Copyright 2017 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="4b68ee6824f9d7bc05d394ec75a66e1193885d88"
CROS_WORKON_TREE=("f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6" "4fc7c463ce102d1dff62e86baffad4a67ea2c940" "1232b5450992d3c45a88234d53a5afd4729a33fc" "44e72bbc38a5680e66be1b6c5862a62fd2a934f4" "4a86cdeef3d62cc86c76c7ec778bb1bff8949cae" "cc92446fd5584f3a227c32f0856ddc541e9bf5f6" "c1016ea8f4046234893bde04cb033fdd20ec71d5" "379618bb76af3b056fdbf5a781ea3bd4152ca237" "fefa46dc07b1045ed94377bd79f0ec4cac20f50a" "bb46f20bc6d2f9e7fb1aa1178d1e47384440de9a" "d59e71ccef5d54ff0d0d3d41a69aa70d60282d7a")
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
	chromeos-base/dlcservice-client:=
	media-libs/cros-camera-hal-usb:=
	media-libs/libsync:=
	libcamera? ( media-libs/libcamera )
	!libcamera? (
		virtual/cros-camera-hal
		virtual/cros-camera-hal-configs
	)"

DEPEND="${RDEPEND}
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
