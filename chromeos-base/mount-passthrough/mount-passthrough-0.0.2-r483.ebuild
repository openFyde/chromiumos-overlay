# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="60d1fad8686e56d4e6ae78fc5041ab6540542564"
CROS_WORKON_TREE=("1f02e90df08e7f8c0093b14f2660828e06d87ef7" "2fa93f85a579bcd5b57a3bc933afcf45c205f9ee" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD="1"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk arc/mount-passthrough .gn"

PLATFORM_SUBDIR="arc/mount-passthrough"

inherit cros-workon platform

DESCRIPTION="Mounts the specified directory with different owner UID and GID"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/arc/mount-passthrough"

LICENSE="BSD-Google"
KEYWORDS="*"

COMMON_DEPEND="sys-fs/fuse:=
	sys-libs/libcap:="
RDEPEND="${COMMON_DEPEND}"
DEPEND="${COMMON_DEPEND}"

src_install() {
	dobin "${OUT}"/mount-passthrough
	dobin mount-passthrough-jailed
	dobin mount-passthrough-jailed-media
	dobin mount-passthrough-jailed-play

	insinto /usr/share/arc
	doins mount-passthrough-jailed-utils.sh
}
