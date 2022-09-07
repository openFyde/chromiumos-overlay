# Copyright 2022 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_RUST_REMOVE_DEV_DEPS=1

inherit cros-rust

DESCRIPTION='The rust language implementation of gRPC, base on the gRPC c core library.'
HOMEPAGE='https://github.com/tikv/grpc-rs'
SRC_URI="https://crates.io/api/v1/crates/${PN}/${PV}/download -> ${P}.crate"

LICENSE="Apache-2.0"
SLOT="${PV}/${PR}"
KEYWORDS="*"

DEPEND="
	=dev-rust/bytes-1*
	=dev-rust/futures-0.3*
	=dev-rust/grpcio-sys-0.9*
	=dev-rust/libc-0.2*
	=dev-rust/log-0.4*
	=dev-rust/parking_lot-0.11*
	=dev-rust/prost-0.7*
	=dev-rust/protobuf-2*
"
RDEPEND="${DEPEND}"

# This file was automatically generated by cargo2ebuild.py
