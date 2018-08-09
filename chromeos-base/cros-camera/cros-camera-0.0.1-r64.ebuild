# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT=("d077152a94e5b5bf38e0bb8b0506e5e37b43eded" "1e8726b13b708d5ec98e846939b6ff5f437ed536")
CROS_WORKON_TREE=("6589055d0d41e7fc58d42616ba5075408d810f7d" "c1e06d9f00c106dff199c84c68f58508a9332bac" "a94c4f5a6ed17332e20dbdbfe291b3188587d757" "15c6d2b3c8226508b7434556acbda449e788a508" "04d2f915e83148f85ce085e7ee18f2506ec85a47" "0148ea45412dc2cc546e2cdad0b406e5c2fe6683")
CROS_WORKON_PROJECT=(
	"chromiumos/platform/arc-camera"
	"chromiumos/platform2"
)
CROS_WORKON_LOCALNAME=(
	"../platform/arc-camera"
	"../platform2"
)
CROS_WORKON_DESTDIR=(
	"${S}/platform/arc-camera"
	"${S}/platform2"
)
CROS_WORKON_SUBTREE=(
	"build common hal_adapter include mojo"
	"common-mk"
)
PLATFORM_GYP_FILE="hal_adapter/cros_camera_service.gyp"

inherit cros-camera cros-constants cros-workon user

DESCRIPTION="Chrome OS camera service. The service is in charge of accessing
camera device. It uses unix domain socket to build a synchronous channel."

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE="cheets +cros-camera-algo-sandbox"

RDEPEND="
	chromeos-base/libbrillo
	!media-libs/arc-camera3
	cros-camera-algo-sandbox? ( media-libs/cros-camera-libcab )
	media-libs/cros-camera-hal-usb
	media-libs/cros-camera-libcamera_common
	media-libs/cros-camera-libcamera_metadata
	media-libs/libsync
	virtual/cros-camera-hal
	virtual/cros-camera-hal-configs"

DEPEND="${RDEPEND}
	chromeos-base/libmojo
	media-libs/cros-camera-android-headers
	media-libs/minigbm
	virtual/pkgconfig
	x11-libs/libdrm"

src_unpack() {
	cros-camera_src_unpack
}

src_install() {
	dobin "${OUT}/cros_camera_service"

	insinto /etc/init
	doins hal_adapter/init/cros-camera.conf

	# Install seccomp policy file.
	insinto /usr/share/policy
	newins "hal_adapter/seccomp_filter/cros-camera-${ARCH}.policy" cros-camera.policy

	if use cheets; then
		insinto "${ARC_VENDOR_DIR}/etc/init"
		doins hal_adapter/init/init.camera.rc
	fi
}

pkg_preinst() {
	enewuser "arc-camera"
	enewgroup "arc-camera"
}
