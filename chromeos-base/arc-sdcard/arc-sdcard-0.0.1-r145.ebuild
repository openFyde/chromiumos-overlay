# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

CROS_WORKON_COMMIT="8bd1042f66b665c37ca24cec2f7c0908bff56a5f"
CROS_WORKON_TREE=("ce312a57a100a69f5e2d0f8f445e1f6c7604fc95" "8507735579e7fc9b3850039ffb51c77c9c39c64c" "dc1506ef7c8cfd2c5ffd1809dac05596ec18773c")
CROS_WORKON_INCREMENTAL_BUILD="1"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk arc/sdcard .gn"

PLATFORM_SUBDIR="arc/sdcard"

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
