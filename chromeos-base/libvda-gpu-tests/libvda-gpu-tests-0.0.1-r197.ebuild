# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

CROS_WORKON_COMMIT="d7d02e3d3be256c2f8a276083494cb73428fa44f"
CROS_WORKON_TREE=("c23e9bd8eaa54cbd599b1a7aca04009fd33af563" "835cfa4f1aef2186f1c57c5fb5d04f50fc0f3fd7" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
