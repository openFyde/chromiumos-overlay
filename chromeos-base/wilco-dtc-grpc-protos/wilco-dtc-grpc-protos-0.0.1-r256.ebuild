# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CROS_WORKON_COMMIT="919e4173733b8880496b873211cd25c1909c67cf"
CROS_WORKON_TREE=("1127da40f25ab9f6f6d1c708ffc1308fbfff5f0e" "48152c166377a472e88e63a8996aeb920ac44e0a" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_GO_PACKAGES=(
	"chromiumos/wilco_dtc/..."
)

CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk diagnostics/grpc .gn"

PLATFORM_SUBDIR="diagnostics/grpc"

WANT_LIBCHROME="no"
WANT_LIBBRILLO="no"
inherit cros-go cros-workon platform

DESCRIPTION="Chrome OS Wilco DTC proto/gRPC API"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/diagnostics/grpc"
LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"

RDEPEND="
	dev-libs/protobuf:=
	dev-go/protobuf-legacy-api:=
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
