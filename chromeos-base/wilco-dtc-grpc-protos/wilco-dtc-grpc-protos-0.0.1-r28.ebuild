# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CROS_WORKON_COMMIT="ae4596f82377173dbc159973e5f1c48ec3b7db66"
CROS_WORKON_TREE=("94b68506644467afb2672fbb562f302dc8bcf738" "25a817c1c3ca6fa0c70cad2511f2839bf82e1762" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
inherit cros-go cros-workon multilib platform

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
