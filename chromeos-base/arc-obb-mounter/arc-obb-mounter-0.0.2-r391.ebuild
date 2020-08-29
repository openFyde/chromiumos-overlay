# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="fda7723bb7a45184ab59d6f6ec0eed96d1264477"
CROS_WORKON_TREE=("b6b10e03115551b69ba9e2502b15d5467adcd107" "b501ee2aedd82ddcf3afe971b4b9cc3a4b328763" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
KEYWORDS="*"

RDEPEND="
	sys-fs/fuse:=
	sys-libs/libcap:=
"

DEPEND="${RDEPEND}"

BDEPEND="
	virtual/pkgconfig
"


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

	platform_fuzzer_install "${S}"/OWNERS "${OUT}"/mount-obb_fuzzer
}

platform_pkg_test() {
	platform_test "run" "${OUT}/arc-obb-mounter_testrunner"
}
