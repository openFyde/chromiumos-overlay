# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="b493dd5021f363e786ae38e91cf1aacac4be09cd"
CROS_WORKON_TREE=("f905fe98db2d0449c22fbe838b6fd28cc89e5443" "a050dd7c355cb42fde90fdb9c3c4334389d0acb5" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD="1"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk arc/container/sdcard .gn"

PLATFORM_SUBDIR="arc/container/sdcard"

inherit cros-workon platform

DESCRIPTION="Container to run Android's sdcard daemon."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/arc/container/sdcard"

LICENSE="BSD-Google"
KEYWORDS="*"

# CONTAINER_DIR must be kept consistent with installation configuration in
# ${PLATFORM_SUBDIR}/BUILD.gn.
CONTAINER_DIR="/opt/google/containers/arc-sdcard"

RDEPEND=""

src_install() {
	platform_install

	# Keep the parent directory of mountpoints inaccessible from non-root
	# users because mountpoints themselves are often world-readable but we
	# do not want to expose them.
	# container-root is where the root filesystem of the container in which
	# arc-obb-mounter daemon runs is mounted.
	diropts --mode=0700 --owner=root --group=root
	keepdir "${CONTAINER_DIR}"/mountpoints/
	keepdir "${CONTAINER_DIR}"/mountpoints/container-root
}
