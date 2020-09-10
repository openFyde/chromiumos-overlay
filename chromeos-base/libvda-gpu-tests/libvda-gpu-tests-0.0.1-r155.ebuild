# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

CROS_WORKON_COMMIT="f1d892b43c2170b8960364f75585484ed0a4448f"
CROS_WORKON_TREE=("b2d7995ab106fbf61493d108c2bfd78d1a721d83" "eadd6ab5f1eb0e87dd35681e68ab45bfcd5a68e4" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD="1"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk arc/vm/libvda .gn"

PLATFORM_SUBDIR="arc/vm/libvda"

inherit cros-workon platform

DESCRIPTION="libvda Chrome GPU tests"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/arc/vm/libvda"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE=""

RDEPEND="
	chromeos-base/libbrillo:=
	media-libs/minigbm:=
"

DEPEND="
	${RDEPEND}
	chromeos-base/system_api:=
"

src_compile() {
	platform "compile" "libvda_gpu_unittest"
}

src_install() {
	exeinto /usr/libexec/libvda-gpu-tests
	doexe "${OUT}/libvda_gpu_unittest"
}
