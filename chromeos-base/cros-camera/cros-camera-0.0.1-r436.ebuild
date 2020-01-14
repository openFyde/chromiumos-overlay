# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="2884c52ea612b980bb15db80fedd758d139c27b3"
CROS_WORKON_TREE=("e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "d58be6324ba2a1d0452d23bafb39c869c5ed2cd6" "8c1f3d4dbebee980baa073247d925809df88f712" "6be71752e10e604bedba3c34d61e630795d7a144" "0211dc05f45b88ef8a95467f0e004b5520f26ed6" "e572ce47cbda62e83f0a8793e74d4189ffef3238" "ce7f8b7d17ca5ea5acf26e9d0329b53f518f0336" "81f7fe23bf497aafef6d4128b33582b4422a9ff5" "ede0d83eb33d420aed3eda5806ccd357881b4bb0")
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
IUSE="arc-camera1 cheets +cros-camera-algo-sandbox"

BDEPEND="virtual/pkgconfig"

COMMON_DEPEND="
	!media-libs/arc-camera3
	cros-camera-algo-sandbox? ( media-libs/cros-camera-libcab:= )
	media-libs/cros-camera-hal-usb:=
	media-libs/cros-camera-libcamera_common:=
	media-libs/cros-camera-libcamera_ipc:=
	media-libs/cros-camera-libcamera_metadata:=
	media-libs/libsync:=
	virtual/cros-camera-effects
	virtual/cros-camera-hal
	virtual/cros-camera-hal-configs"

RDEPEND="${COMMON_DEPEND}"

DEPEND="${COMMON_DEPEND}
	chromeos-base/metrics:=
	media-libs/cros-camera-android-headers:=
	media-libs/minigbm:=
	x11-libs/libdrm:="

src_install() {
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
