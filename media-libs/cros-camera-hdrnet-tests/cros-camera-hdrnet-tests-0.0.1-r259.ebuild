# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="5033458846a050c8a5b8e831a5e41ada9c6c15ad"
CROS_WORKON_TREE=("e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "bdce8a305b6af438503ba12680e7d8526bcc2dfc" "ab6bff96fc0aa698221787a6286f2e0d177ffc28" "e8c8ddc463c0f9f733053b2a4a0f6fda2d26c85c" "29d52c6d2464057e3fde8214a173f96d96f3b267" "2d6446844ef081b6958e8938c05cff3b62f53cd6" "0a6d4dbdf397fb89f6c03afb0230c188ae632ead" "01ea4b1e89917ab2eace86defdfd6a6a65655c6b" "8ff1eab586712c03641dda82a1877dfc4cd6eb72" "8a9ef8758fbc933dbbb61914e0a924d6fd9626f6" "7f75062369f81d0a20d6235046dafa9416de6f02")
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
