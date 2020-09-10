# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="c8b48d7dfb0c4714a5e6ec76703701b6055d5eea"
CROS_WORKON_TREE=("e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "d58be6324ba2a1d0452d23bafb39c869c5ed2cd6" "ec3217d22fb7916f21ba8d63a8ef08eb9bc45916" "aec5bf0778682ecdbe1f1566fbf1439dc18891c5" "e885a36a16305efc80401bbc17d9a304c25e8b79" "4cc600d625ecfdac13d984d9190d63a8970b0a4b" "ab72b93074396d3428b557e2e00d64f487fab1e1" "b6b10e03115551b69ba9e2502b15d5467adcd107" "86cbea444f4155f2ac059fd59747fe5000df718d")
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
