# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="ce7bd3e8c3c14d250a69724b2169a9c86e80c7cb"
CROS_WORKON_TREE=("43c775da3a7b44c1defe92c3f3d3e36406948fb3" "c73e1f37fdaafa35e9ffaf067aca34722c2144cd" "8c023eadea52731e3bc8c3d0ea81972cf03a3ea9" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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

pkg_setup() {
	# Has to be done in pkg_setup() instead of pkg_preinst() since
	# src_install() needs <daemon_user> and <daemon_group>.
	enewuser "fuse-smbfs"
	enewgroup "fuse-smbfs"
	cros-workon_pkg_setup
}

src_install() {
	dosbin "${OUT}"/smbfs

	insinto /usr/share/policy
	newins seccomp_filters/smbfs-seccomp-"${ARCH}".policy smbfs-seccomp.policy

	local daemon_store="/etc/daemon-store/smbfs"
	dodir "${daemon_store}"
	fperms 0700 "${daemon_store}"
	fowners fuse-smbfs:fuse-smbfs "${daemon_store}"
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
