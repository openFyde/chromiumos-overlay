# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT=("b1567e81e96ca22c40c3bd87ed475a7c7ceeed8d" "a1ff2472b257de3d5ec19609ddb374eeaa0a283b")
CROS_WORKON_TREE=("6589055d0d41e7fc58d42616ba5075408d810f7d" "2835984e4f7c26a6c0ad234cf5cd650a4b0b6266" "84a11a07b1c2c754c0ed481033807269491150ea" "f62010221e3eb0566f97bc9fe74a5d47808c8cc4" "62e34ac946e6d1a95cc072d886d6a7087bb6c820" "2cc251457e1e4f18477bcb58f0117ef2d6e98842")
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
