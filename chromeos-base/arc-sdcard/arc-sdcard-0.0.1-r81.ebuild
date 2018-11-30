# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

CROS_WORKON_COMMIT="ff6532b9bafea6c0b643a545303ef3b7e9352e1a"
CROS_WORKON_TREE=("310a710d6c1f02a93504b35b3d8371875f253b6a" "118698016a854018a34b2fb3b5c32e8a21bbf89d" "dc1506ef7c8cfd2c5ffd1809dac05596ec18773c")
CROS_WORKON_INCREMENTAL_BUILD="1"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk arc/sdcard .gn"

PLATFORM_SUBDIR="arc/sdcard"
PLATFORM_GYP_FILE="sdcard.gyp"

inherit cros-workon platform

DESCRIPTION="Container to run Android's sdcard daemon."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/arc/sdcard"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE="esdfs"

CONTAINER_DIR="/opt/google/containers/arc-sdcard"

src_install() {
	if ! use esdfs; then
		insinto /etc/init
		doins arc-sdcard.conf
	fi

	insinto "${CONTAINER_DIR}"
	doins "${OUT}"/rootfs.squashfs

	# Keep the parent directory of mountpoints inaccessible from non-root
	# users because mountpoints themselves are often world-readable but we
	# do not want to expose them.
	# container-root is where the root filesystem of the container in which
	# arc-obb-mounter daemon runs is mounted.
	diropts --mode=0700 --owner=root --group=root
	keepdir "${CONTAINER_DIR}"/mountpoints/
	keepdir "${CONTAINER_DIR}"/mountpoints/container-root
}
