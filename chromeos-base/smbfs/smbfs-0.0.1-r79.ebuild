# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="fb5d46a109f9ebeaf371604b4375cc696f6505a4"
CROS_WORKON_TREE=("94bdce168a00f19903b3dd162e8e755cee9bbbf8" "c73e1f37fdaafa35e9ffaf067aca34722c2144cd" "c127eb589e82df47c9e285a2f74d6ecccc767de6" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_DESTDIR="${S}/platform2"
# TODO(crbug.com/809389): Avoid directly including headers from other packages.
CROS_WORKON_SUBTREE="common-mk libpasswordprovider smbfs .gn"

PLATFORM_SUBDIR="smbfs"

inherit cros-workon platform user

DESCRIPTION="FUSE filesystem to mount SMB shares."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/smbfs/"

LICENSE="BSD-Google"
SLOT="0/0"
KEYWORDS="*"

COMMON_DEPEND="
	=sys-fs/fuse-2.9*:=
	net-fs/samba:=
"

RDEPEND="${COMMON_DEPEND}"
DEPEND="
	${COMMON_DEPEND}
	chromeos-base/system_api:=
	chromeos-base/libpasswordprovider:=
"

pkg_preinst() {
	enewuser "fuse-smbfs"
	enewgroup "fuse-smbfs"
}

src_install() {
	dosbin "${OUT}"/smbfs

	insinto /usr/share/policy
	newins seccomp_filters/smbfs-seccomp-"${ARCH}".policy smbfs-seccomp.policy
}

platform_pkg_test() {
	local tests=(
		smbfs_test
	)

	local test_bin
	for test_bin in "${tests[@]}"; do
		platform_test "run" "${OUT}/${test_bin}"
	done
}
