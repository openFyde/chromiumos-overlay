# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="0f2d8cef0c5fa29437a2d56e40dd3003e0e5f503"
CROS_WORKON_TREE=("502ac8c8eeb9e928045eb92752f420ddd406348c" "247e372ab67fe6e6740b659029a3a9c865e18d4e" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
