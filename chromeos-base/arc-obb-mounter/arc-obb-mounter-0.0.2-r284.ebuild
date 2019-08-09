# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

CROS_WORKON_COMMIT="f8e07dae2ad8c152a76d7c76e3cbf9cf2471dcfb"
CROS_WORKON_TREE=("34ec149bfffef93be14397dd8372e9c1bdbe7bfe" "4e96337bc70ac3c35073afecd6c6fb6e785a46d8" "dc1506ef7c8cfd2c5ffd1809dac05596ec18773c")
CROS_WORKON_INCREMENTAL_BUILD="1"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk arc/obb-mounter .gn"

PLATFORM_SUBDIR="arc/obb-mounter"

inherit cros-workon platform

DESCRIPTION="D-Bus service to mount OBB files"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/arc/obb-mounter"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"

RDEPEND="
	chromeos-base/libbrillo
	sys-fs/fuse
	sys-libs/libcap
"

DEPEND="${RDEPEND}
	virtual/pkgconfig"

CONTAINER_DIR="/opt/google/containers/arc-obb-mounter"

src_install() {
	dobin "${OUT}"/arc-obb-mounter
	dobin "${OUT}"/mount-obb

	insinto /etc/dbus-1/system.d
	doins org.chromium.ArcObbMounter.conf

	insinto /etc/init
	doins init/arc-obb-mounter.conf

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

platform_pkg_test() {
	platform_test "run" "${OUT}/arc-obb-mounter_testrunner"
}
