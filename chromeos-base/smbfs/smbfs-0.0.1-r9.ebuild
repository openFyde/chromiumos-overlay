# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

CROS_WORKON_COMMIT="b6899564618a19219fc887935514be4175d1ce27"
CROS_WORKON_TREE=("bf84a23a00350764b97d4ceb2bee5c17164d7855" "7234ffaaadc15ea9cdb02b7e72d4e29ad174114a" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_DESTDIR="${S}/platform2"
CROS_WORKON_SUBTREE="common-mk smbfs .gn"

PLATFORM_SUBDIR="smbfs"

inherit cros-workon platform user

DESCRIPTION="FUSE filesystem to mount SMB shares."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/smbfs/"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"

RDEPEND="
	=sys-fs/fuse-2.9*
	net-fs/samba
"

DEPEND="
	${RDEPEND}
"

pkg_preinst() {
	enewuser "fuse-smbfs"
	enewgroup "fuse-smbfs"
}

src_install() {
	dosbin "${OUT}"/smbfs
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
