# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="ac131b5b434a487e5e924a07929fed0ad88094c3"
CROS_WORKON_TREE=("dff428784a910a64f792e769916f70d39ac7406a" "7a0977e263f3f9969fb2db8cbeafbb4bdc1f8bb4" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
