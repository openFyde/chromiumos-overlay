# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="822c8358c04b178315320b08fb67a930e3dda95c"
CROS_WORKON_TREE=("e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "4be8d3ae5664634825afc2e6e4b8c24816ee9b9e" "d65fd015bbc9ccb1bc79941a26901cd16c3eb638" "98e14b065465da9503e1e0083b78f5b5b59fbefb" "29d52c6d2464057e3fde8214a173f96d96f3b267" "b4f8e0fdb56de65a80463b298f88c6368df1950d" "aae8bf048bbe1147ff2aa47f59de29bad1b6355d" "38710905fc38d218f0537e67abef96ffbe2f56bc" "e7f63c823468db13a24ebe2323042c054c4316c9" "8a9ef8758fbc933dbbb61914e0a924d6fd9626f6" "7f75062369f81d0a20d6235046dafa9416de6f02")
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
