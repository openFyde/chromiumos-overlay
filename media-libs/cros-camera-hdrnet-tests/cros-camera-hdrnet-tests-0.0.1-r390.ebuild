# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="e7e4e6825a0edcb20fda4e68156cbe730d30dd10"
CROS_WORKON_TREE=("e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "56ebaba2bbb985bdfae612ea5533ddf02fdf1548" "46146d8d8c9e31088a57edb9687fc03698845326" "dfca03ac1f2edbf642708af0992891cc93024aa8" "b5413a1de5fea67b73a33d2bda74fdcfa0fb8ed6" "95cb3d0b604e91088158d606fd0aeeb073d62224" "8821bec7557652f636e7eed8ee7944b23b50b4b8" "be685e50cd6402b6c71b394cbc9798b07b526ef1" "db382a13f6e22c79a09ffb69ca5a504dcf6c9bd5" "8a9ef8758fbc933dbbb61914e0a924d6fd9626f6" "6c730fa6bc9c00d204b80c4944f1951b8f35a48e")
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="../platform2"
# iioservice/ is included just to make sandbox happy when running `gn gen`.
CROS_WORKON_SUBTREE=".gn camera/build camera/features camera/include camera/gpu camera/common camera/mojo chromeos-config common-mk iioservice/libiioservice_ipc iioservice/mojo"
CROS_WORKON_OUTOFTREE_BUILD="1"
CROS_WORKON_INCREMENTAL_BUILD="1"

PLATFORM_SUBDIR="camera/features/hdrnet/tests"

inherit cros-workon platform

DESCRIPTION="Chrome OS camera HDRnet integration tests"

LICENSE="BSD-Google"
KEYWORDS="*"

# 'ipu6' and 'ipu6ep' are passed to and used in BUILD.gn files.
IUSE="ipu6 ipu6ep"

BDEPEND="virtual/pkgconfig"

RDEPEND="
	chromeos-base/cros-camera-android-deps:=
	chromeos-base/cros-camera-libs:=
	dev-cpp/benchmark:=
	dev-cpp/gtest:=
	media-libs/cros-camera-libfs:=
	virtual/opengles:=
"

DEPEND="${RDEPEND}
	x11-drivers/opengles-headers:=
"

src_configure() {
	cros_optimize_package_for_speed
	platform_src_configure
}

src_install() {
	dobin "${OUT}"/hdrnet_stream_manipulator_test
	dobin "${OUT}"/hdrnet_processor_impl_test
	dobin "${OUT}"/hdrnet_processor_benchmark
	platform_src_install
}
