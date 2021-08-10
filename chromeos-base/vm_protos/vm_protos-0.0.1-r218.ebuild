# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="60d1fad8686e56d4e6ae78fc5041ab6540542564"
CROS_WORKON_TREE=("1f02e90df08e7f8c0093b14f2660828e06d87ef7" "0902dfd7f1e986417b6e28673d58f997a9752f53" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_GO_PACKAGES=(
	"chromiumos/vm_tools/..."
)

CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk vm_tools/proto .gn"

PLATFORM_SUBDIR="vm_tools/proto"

inherit cros-go cros-workon platform

DESCRIPTION="Chrome OS VM protobuf API"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/vm_tools/proto"
LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="fuzzer"

RDEPEND="
	dev-libs/protobuf:=
	net-libs/grpc:=
	!<chromeos-base/vm_guest_tools-0.0.2
	!<chromeos-base/vm_host_tools-0.0.2
"
DEPEND="
	${RDEPEND}
	dev-go/protobuf:=
	dev-go/grpc:=
"

src_unpack() {
	platform_src_unpack
	CROS_GO_WORKSPACE="${OUT}/gen/go"
}

src_install() {
	insinto /usr/"$(get_libdir)"/pkgconfig
	doins vm_protos.pc

	insinto /usr/include/vm_protos/proto_bindings
	doins "${OUT}"/gen/include/vm_protos/proto_bindings/*.h

	dolib.a "${OUT}"/*.a

	cros-go_src_install
}
