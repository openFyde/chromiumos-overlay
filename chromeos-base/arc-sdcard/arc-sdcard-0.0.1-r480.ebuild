# Copyright 2018 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="9e6b424caa95299b286811d4b6c1f3783edc77bd"
CROS_WORKON_TREE=("e44d7e66ab4ccaab888a42ade972724af9621706" "3c4e06bca7e65b43f219abdec9ba34c34201f065" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
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
	platform_src_install

	# Keep the parent directory of mountpoints inaccessible from non-root
	# users because mountpoints themselves are often world-readable but we
	# do not want to expose them.
	# container-root is where the root filesystem of the container in which
	# arc-obb-mounter daemon runs is mounted.
	diropts --mode=0700 --owner=root --group=root
	keepdir "${CONTAINER_DIR}"/mountpoints/
	keepdir "${CONTAINER_DIR}"/mountpoints/container-root
}
