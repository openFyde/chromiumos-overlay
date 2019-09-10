# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CROS_WORKON_COMMIT="623feefcd51ef5eb26b629fe64a8845b68b776a9"
CROS_WORKON_TREE=("fd02e6090c8f07ce200c4a4a20eefc55a064dc6d" "cae0b01fb0715f9f3d1604f78accf8e688c0b368" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_SUBTREE="common-mk diagnostics .gn"

PLATFORM_SUBDIR="diagnostics/dpsl"

inherit cros-workon platform

DESCRIPTION="Diagnostics DPSL test designed to be run inside VM"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/diagnostics/dpsl/"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE=""

DEPEND="
	chromeos-base/libbrillo:=
"
RDEPEND="
	net-libs/grpc:=
	dev-libs/protobuf:=
"

src_install() {
	dobin "${OUT}/diagnostics_dpsl_demo_vm"
}
