# Copyright 2021 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="cb977bbdbbd9a4c35dcce1cb68de3eb25b1d1952"
CROS_WORKON_TREE=("f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6" "952d2f368a90cdfa98da94394d2a56079cef3597" "22d5274d1e7570d1be474dd10560ef20113f4d3c" "67326aa19f1aee5051aefd50a959b82d12643540" "06a2fbf765ecfda3b733c3d1af5c13d6a6ff6519" "9fad03618cc0c623614d9cc45597a67cd3f8c212" "56d11be3eee2e1ae4822f70f73b6e8cc7a4082c8" "5173d4b89e762b0b8012bdf26edff3b6de7eeda3" "2c1654d2485bf7fd97544265dc582a0c396bd4dc" "9bfa7804e9236c6a7d1a8b25953d4ba68c246f63" "1e601fb1df98e9ea9f5803aeb50bd6fbec835a2a" "e40ac435946a5417104d844a323350d04e9d3b2e" "3b11fc6ac3a2ed2e40dfa6d862da597b72fd883d")
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_SUBTREE=".gn common-mk metrics camera/build camera/common camera/features camera/gpu camera/include camera/mojo chromeos-config iioservice/libiioservice_ipc iioservice/mojo ml_core"
CROS_WORKON_OUTOFTREE_BUILD="1"
CROS_WORKON_INCREMENTAL_BUILD="1"

PLATFORM_SUBDIR="camera/common"

inherit cros-camera cros-constants cros-workon platform

DESCRIPTION="Chrome OS camera common libraries."

LICENSE="BSD-Google"
KEYWORDS="*"

# 'camera_feature_*' and 'ipu6*' are passed to and used in BUILD.gn files.
IUSE="camera_feature_auto_framing camera_feature_face_detection camera_feature_frame_annotator camera_feature_hdrnet camera_feature_portrait_mode camera_feature_effects ipu6 ipu6ep ipu6se qualcomm_camx"

# Auto face framing depends on the face detection feature.
REQUIRED_USE="camera_feature_auto_framing? ( camera_feature_face_detection )"

BDEPEND="virtual/pkgconfig"

# TODO: Remove the conflicting packages
CONFLICTING_PACKAGES="
	!media-libs/cros-camera-libcab
	!media-libs/cros-camera-libcam_gpu_algo
	!media-libs/cros-camera-libcamera_common
	!media-libs/cros-camera-libcamera_connector
	!media-libs/cros-camera-libcamera_exif
	!media-libs/cros-camera-libcamera_ipc
	!media-libs/cros-camera-libcamera_timezone
	!media-libs/cros-camera-libcamera_v4l2_device
	!media-libs/cros-camera-libcbm
	!media-libs/cros-camera-libjda
"

RDEPEND="
	${CONFLICTING_PACKAGES}
	chromeos-base/chromeos-config-tools:=
	chromeos-base/cros-camera-android-deps:=
	dev-libs/ml-core:=
	media-libs/cros-camera-libfs:=
	media-libs/libexif:=
	media-libs/libsync:=
	media-libs/minigbm:=
	virtual/libudev:=
	virtual/opengles:=
	x11-libs/libdrm:=
"

DEPEND="
	${RDEPEND}
	>=chromeos-base/metrics-0.0.1-r3152:=
	media-libs/cros-camera-libcamera_connector_headers:=
	media-libs/libyuv:=
	x11-base/xorg-proto:=
	x11-drivers/opengles-headers:=
"

src_configure() {
	cros_optimize_package_for_speed
	platform_src_configure
}

src_install() {
	local fuzzer_component_id="167281"
	platform_fuzzer_install "${S}"/OWNERS \
			"${OUT}"/camera_still_capture_processor_impl_fuzzer \
			--comp "${fuzzer_component_id}"
	platform_src_install
}

platform_pkg_test() {
	platform test_all
}
