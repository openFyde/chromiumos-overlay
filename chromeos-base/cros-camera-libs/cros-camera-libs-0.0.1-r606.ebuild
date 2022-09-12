# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="63f953f3f1b9573ebcdbae9c1dd27322654b94a5"
CROS_WORKON_TREE=("e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "b9732f2bc7bbc922b1abb9212879b987c70537a8" "19f36342be7994842e12ce8eadbb21be2e51ae97" "5fc34f384cd5fc6a13144a7f836f2371938bb8a6" "f386c5ad3b69b5be8dd06422610d7f81853224be" "4cededda1d9b1e5ffd5d2fb58e1f67254599c6a2" "b5413a1de5fea67b73a33d2bda74fdcfa0fb8ed6" "c457b08fd133fa46cd7a5cd2f8b4c1a783ceca8a" "8821bec7557652f636e7eed8ee7944b23b50b4b8" "905de1b1a650f3a518fda231b371365a4954e6f5" "8a9ef8758fbc933dbbb61914e0a924d6fd9626f6" "6c730fa6bc9c00d204b80c4944f1951b8f35a48e" "75360a52c58cd825413d38cf390502a37b3b8447")
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

	insinto /usr/include/cros-camera/mojo/iioservice
	doins -r "${OUT}"/gen/include/iioservice/mojo

	dolib.so "${OUT}"/lib/libcros_camera.so
	dolib.a "${OUT}"/libcros_camera_mojom.a
	# Project Pita libraries need libcamera_connector.so to run.
	dosym libcros_camera.so /usr/"$(get_libdir)"/libcamera_connector.so

	insinto /usr/"$(get_libdir)"/pkgconfig
	doins "${OUT}"/obj/camera/common/libcros_camera.pc

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
