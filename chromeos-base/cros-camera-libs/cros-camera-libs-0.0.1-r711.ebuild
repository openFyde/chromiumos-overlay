# Copyright 2021 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="5099aa587162b4a99fc6ded6c162efd211fabc04"
CROS_WORKON_TREE=("f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6" "ebcce78502266e81f55c63ade8f25b8888e2c103" "db75597a3a702c90030f8f50dee1f1f79046be1a" "3a939e262dbbb04bab2434b9e34a18e1f4cbda60" "e875c6eb18919131842b7acdfd210b2974eeb516" "1d82496c9809ba0d30d0f5bb0d2ebad6b0cff967" "a9a69ecbf7bea295e96aa24cfb57d74046935663" "aaef5d5dd5a995d20e5b04eab1d9142563ee9829" "a0af00390c3d3c63903578edd1d7c7cb504a8699" "cb6c2260ebebf2c6a79ea0708d4e6c02cd499c3b" "7ddb8f962dd6611aef849f6a4c0ed7268cedb699" "6da0a978ba1edbe645822f82ddb2493d34ecf9f7" "a8047dd7acc05f8f902fc189c8dc1eb38f11ea4c" "e8f85bfe9d17faf78152c420b3262763eea7aad5")
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_SUBTREE=".gn common-mk metrics camera/build camera/common camera/features camera/gpu camera/include camera/mojo chromeos-config iioservice/libiioservice_ipc iioservice/mojo ml_core ml_core/mojo"
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
	camera_feature_effects? ( dev-libs/ml-core:= )
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
	# Install the sandboxed algorithm service.
	dobin "${OUT}"/cros_camera_algo

	insinto /etc/init
	doins init/cros-camera-algo.conf

	insinto /etc/dbus-1/system.d
	doins dbus/CrosCameraAlgo.conf

	insinto /usr/share/policy
	newins "seccomp_filter/cros-camera-algo-${ARCH}.policy" cros-camera-algo.policy

	# The sandboxed GPU service is used by Portrait Mode feature, IPU6SE
	# and Qualcomm Camx camera HAL.
	if use camera_feature_portrait_mode || use ipu6se || use qualcomm_camx; then
		insinto /etc/init
		doins init/cros-camera-gpu-algo.conf

		insinto /usr/share/policy
		newins "seccomp_filter/cros-camera-gpu-algo-${ARCH}.policy" cros-camera-gpu-algo.policy
	fi

	# Install libcros_camera required by the camera HAL implementations.
	insinto /usr/include/cros-camera/
	doins -r ../include/cros-camera/*
	# TODO(crbug.com/1197394): Remove after the issue is resolved.
	camera_mojo_files=$(find "${OUT}"/gen/include/camera/mojo -name '*.mojom.h')
	einfo "${camera_mojo_files}"
	insinto /usr/include/cros-camera/mojo/camera
	doins -r "${OUT}"/gen/include/camera/mojo

	insinto /usr/include/cros-camera/mojo/ml_core
	doins -r "${OUT}"/gen/include/ml_core/mojo

	insinto /usr/include/cros-camera/mojo/iioservice
	doins -r "${OUT}"/gen/include/iioservice/mojo

	dolib.so "${OUT}"/lib/libcros_camera.so
	dolib.a "${OUT}"/libcros_camera_mojom.a
	# Project Pita libraries need libcamera_connector.so to run.
	dosym libcros_camera.so /usr/"$(get_libdir)"/libcamera_connector.so

	insinto /usr/"$(get_libdir)"/pkgconfig
	doins "${OUT}"/obj/camera/common/libcros_camera.pc

	dolib.so "${OUT}"/lib/libcros_camera_device_config.so
	insinto /usr/"$(get_libdir)"/pkgconfig
	doins "${OUT}"/obj/camera/common/libcros_camera_device_config.pc

	local fuzzer_component_id="167281"
	platform_fuzzer_install "${S}"/OWNERS \
			"${OUT}"/camera_still_capture_processor_impl_fuzzer \
			--comp "${fuzzer_component_id}"

	platform_src_install
}

platform_pkg_test() {
	local cros_camera_tests=(
		camera_buffer_pool_test
		camera_face_detection_test
		camera_hal3_helpers_test
		cbm_test
		embed_file_toc_test
		future_test
		zsl_helper_test
	)
	local test_bin
	for test_bin in "${cros_camera_tests[@]}"; do
		platform_test run "${OUT}/${test_bin}"
	done
}
