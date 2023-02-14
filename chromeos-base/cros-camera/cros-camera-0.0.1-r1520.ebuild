# Copyright 2017 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="855248a9bd9678de4f8b2a61eba2349e10289797"
CROS_WORKON_TREE=("f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6" "2ad8679ea3a8f3e8a2509b4b05585f22f2dc373b" "1ae0a0362c01f63ffc8d4810ad74c52d6205a028" "cef2916016bb5de48b768865930d6cdb92fa3dbb" "7f33489067f631fadbf2083ac7f426bb1a051967" "968c01007f7a9f87380db372c14945bc15201d86" "717576512f4c94df8a823dac9da44aaf7570ac51" "8e57c159340e360878b780d73ea9e75c72476f3b" "546d612834bb46518d8ed157a8923c49016e2fb5" "f834e7e40228b458c4100226f262117a9d85cdb3" "8121a859390f3397242920b1bcac3c2d3f46c8e3")
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
}
