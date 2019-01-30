# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT="880bd2dff2582479fa4f44587f43a560186e9796"
CROS_WORKON_TREE=("dc1506ef7c8cfd2c5ffd1809dac05596ec18773c" "c1d6f47d810546f7412d95791a85fb4d35831af3" "a58c305c281cd9c4e21297b843aacf74792daeec" "c407a21eb6dc4328db6123be1d91fcd193c939fa" "bfb7326b116bb6409de072aecd4aed286841c1a1" "df544d9e971b33202110fb8d238784a2f9f9e62d" "2704fc4f555038004e6c9e52db1f60302619e8af" "6f3abf0e1487e52593fe1b4fc780df5844fa9cc1")
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="platform2"
# TODO(crbug.com/914263): camera/hal is unnecessary for this build but is
# workaround for unexpected sandbox behavior.
CROS_WORKON_SUBTREE=".gn camera/build camera/common camera/hal camera/hal_adapter camera/include camera/mojo common-mk"
CROS_WORKON_OUTOFTREE_BUILD="1"
CROS_WORKON_INCREMENTAL_BUILD="1"

PLATFORM_SUBDIR="camera"
PLATFORM_GYP_FILE="hal_adapter/cros_camera_service.gyp"

inherit cros-camera cros-constants cros-workon platform user

DESCRIPTION="Chrome OS camera service. The service is in charge of accessing
camera device. It uses unix domain socket to build a synchronous channel."

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE="arc-camera1 cheets +cros-camera-algo-sandbox"

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

src_install() {
	dobin "${OUT}/cros_camera_service"

	insinto /etc/init
	doins hal_adapter/init/cros-camera.conf

	# Install seccomp policy file.
	insinto /usr/share/policy
	newins "hal_adapter/seccomp_filter/cros-camera-${ARCH}.policy" cros-camera.policy

	if use cheets && ! use arc-camera1; then
		insinto "${ARC_VENDOR_DIR}/etc/init"
		doins hal_adapter/init/init.camera.rc
	fi
}

pkg_preinst() {
	enewuser "arc-camera"
	enewgroup "arc-camera"
}
