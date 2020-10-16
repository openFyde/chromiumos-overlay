# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="10cb5439e0fb4c84150942916eade924c6d72719"
CROS_WORKON_TREE=("e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "d58be6324ba2a1d0452d23bafb39c869c5ed2cd6" "d7fc9e822ea737d22280c42eea3e9c571696dfb8" "311da8ec1b80c604a398a6783ced1b7e0d5ca48a" "5c11dcef038f0e374649137a91e2e1a1b5bda4ea" "85dcd31292e99125b2eb2744c83442e00dece79f" "7efb7c7abf456762653f85c43a01f05aae4fb7ee" "dd4323fe3640909500f29f7acde8c0868024c48a" "9aaa4eb6d654cc8a8c3032148045b634ec3f01ff")
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
