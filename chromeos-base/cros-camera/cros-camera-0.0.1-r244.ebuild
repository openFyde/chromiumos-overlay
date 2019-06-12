# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT="c817e80e0835cf8974932213efb8dd66ad46a947"
CROS_WORKON_TREE=("dc1506ef7c8cfd2c5ffd1809dac05596ec18773c" "c1d6f47d810546f7412d95791a85fb4d35831af3" "47a0a1c0c4f5bdd68b99b1846bfaef7c4c3ba2ad" "67870c655f491a0bc78b1c3b0cfe92f7744a23e4" "419a2ff5b8b3f99a966e17ccd5ca81c830ba0daa" "fa114ae214350b09a867f8cf8f8465412d5b7d89" "6e314ded1aca274c35b5b5fce743f749195aa2a9" "f20ef95ef82c9a0c0b9587bf625efc621a908489" "2654b341562fc7228014b6110e1e2513f7a2353f")
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="platform2"
# TODO(crbug.com/914263): camera/hal is unnecessary for this build but is
# workaround for unexpected sandbox behavior.
CROS_WORKON_SUBTREE=".gn camera/build camera/common camera/hal camera/hal_adapter camera/include camera/mojo common-mk metrics"
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
	chromeos-base/metrics
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
