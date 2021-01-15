# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="44de53b64dd4a6975415747b9bc97f83ce00574c"
CROS_WORKON_TREE=("07bc49d879bc7ffc12a1729033a952d791f7364c" "4561d6fa8ca7fc408c4ab1994661283d2842bdc8" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
