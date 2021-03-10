# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

CROS_WORKON_COMMIT="5f03ce3f3c6b0d190484354cce47934ced7c22ed"
CROS_WORKON_TREE=("eaed4f3b0a8201ef3951bf1960728885ff99e772" "835cfa4f1aef2186f1c57c5fb5d04f50fc0f3fd7" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
