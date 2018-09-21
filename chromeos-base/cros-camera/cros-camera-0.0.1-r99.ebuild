# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT=("c10c2f508b4ed10e1f23d0577673a6396a904eb2" "12495d83b22c0a08af3f779e428e6d21eb40fa37")
CROS_WORKON_TREE=("6589055d0d41e7fc58d42616ba5075408d810f7d" "5d9312be37030d88b1b912ec15b45a0127a88d53" "8b3763d641ee5d837edb20aeeb1cd37f95fbf73c" "f62010221e3eb0566f97bc9fe74a5d47808c8cc4" "62e34ac946e6d1a95cc072d886d6a7087bb6c820" "6e7a51056a0752e4fe787085dbdfbedf6510aba8")
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
	virtual/cros-camera-effects
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
