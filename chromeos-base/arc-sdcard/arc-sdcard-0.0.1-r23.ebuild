# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

CROS_WORKON_COMMIT="31991f352bf891f155bfa8dc34c993c7f3e6c546"
CROS_WORKON_TREE=("17f4a6efa079886fb3e23fd256264f932d59721d" "e1dc3a086911bb1769d282e6ee7f8285a6bb866a")
CROS_WORKON_INCREMENTAL_BUILD="1"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk arc/sdcard"

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
