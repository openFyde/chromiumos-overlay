# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="51a4cfa94c4d9755d787cdf97e11a83d0fd5e48e"
CROS_WORKON_TREE=("e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "c920da127f686c434165b6056b1cd740f228df6b" "da7b73732df1f454a05ffc3efe5a90d416295e3f" "b06768b254a8f054ccc175897b77c5dfe75364c3" "e2575d7a100c9e5e1bfae6a913e68687047a2965" "4a915605af1cd7e632f8e36813007c5403431db2" "a661abd7c4e459764c10f7e466ee615f8c8f0cee" "c9de2eb52379383658eaf7cbc29fdb5d8d32eb98" "853e56035ddc8eed8fe55176525594404096a0c2")
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="platform2"
# TODO(crbug.com/914263): camera/hal is unnecessary for this build but is
# workaround for unexpected sandbox behavior.
CROS_WORKON_SUBTREE=".gn camera/build camera/common camera/hal camera/hal_adapter camera/include camera/mojo common-mk metrics"
CROS_WORKON_OUTOFTREE_BUILD="1"
CROS_WORKON_INCREMENTAL_BUILD="1"

PLATFORM_SUBDIR="camera/hal_adapter"

inherit cros-camera cros-constants cros-workon platform user

DESCRIPTION="Chrome OS camera service. The service is in charge of accessing
camera device. It uses unix domain socket to build a synchronous channel."

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="arc-camera1 cheets +cros-camera-algo-sandbox -libcamera"

BDEPEND="virtual/pkgconfig"

COMMON_DEPEND="
	!media-libs/arc-camera3
	cros-camera-algo-sandbox? ( media-libs/cros-camera-libcab:= )
	media-libs/cros-camera-hal-usb:=
	media-libs/cros-camera-libcamera_common:=
	media-libs/cros-camera-libcamera_ipc:=
	media-libs/cros-camera-libcamera_metadata:=
	media-libs/libsync:=
	libcamera? ( media-libs/libcamera )
	!libcamera? (
		virtual/cros-camera-hal
		virtual/cros-camera-hal-configs
	)"

RDEPEND="${COMMON_DEPEND}"

DEPEND="${COMMON_DEPEND}
	>=chromeos-base/metrics-0.0.1-r3152:=
	media-libs/cros-camera-android-headers:=
	media-libs/minigbm:=
	x11-libs/libdrm:="

src_install() {
	platform_src_install
	dobin "${OUT}/cros_camera_service"

	insinto /etc/init
	doins init/cros-camera.conf

	# Install seccomp policy file.
	insinto /usr/share/policy
	newins "seccomp_filter/cros-camera-${ARCH}.policy" cros-camera.policy

	if use cheets && ! use arc-camera1; then
		insinto "${ARC_VENDOR_DIR}/etc/init"
		doins init/init.camera.rc
	fi
}

pkg_preinst() {
	enewuser "arc-camera"
	enewgroup "arc-camera"
}
