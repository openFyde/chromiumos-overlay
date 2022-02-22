# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="6616ec8883ca6d764f5c519293a3eb87166d95e9"
CROS_WORKON_TREE=("66620b9095b5bf39fa51c8e546595edadafdadaa" "348e1bcce3f170ce3e4e0be69882434a861acfbd" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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

COMMON_DEPEND="=sys-fs/fuse-2*
	sys-libs/libcap:="
RDEPEND="${COMMON_DEPEND}"
DEPEND="${COMMON_DEPEND}"

src_install() {
	platform_install
}
