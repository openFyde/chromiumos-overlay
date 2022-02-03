# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CROS_WORKON_COMMIT="173280e56d1a113f70c6dff28905457bbfa353d3"
CROS_WORKON_TREE=("0a7b5a1cfae096f3966abbfff9976df8159f6343" "59c17a65a89d8ba657de6454bc8dce70a1052ca1" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_GO_PACKAGES=(
	"chromiumos/wilco_dtc/..."
)

CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk diagnostics/grpc .gn"

PLATFORM_SUBDIR="diagnostics/grpc"

WANT_LIBCHROME="no"
WANT_LIBBRILLO="no"
inherit cros-go cros-workon platform

DESCRIPTION="Chrome OS Wilco DTC proto/gRPC API"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/diagnostics/grpc"
LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"

RDEPEND="
	dev-libs/protobuf:=
	net-libs/grpc:=
"
DEPEND="
	${RDEPEND}
	dev-go/protobuf
	dev-go/grpc
"

src_unpack() {
	platform_src_unpack
	CROS_GO_WORKSPACE="${OUT}/gen/go"
}

src_install() {
	insinto /usr/"$(get_libdir)"/pkgconfig
	doins wilco_dtc_grpc_protos.pc

	insinto /usr/include/wilco_dtc/proto_bindings
	doins "${OUT}"/gen/include/*.h

	dolib.a "${OUT}"/*.a

	cros-go_src_install
}
