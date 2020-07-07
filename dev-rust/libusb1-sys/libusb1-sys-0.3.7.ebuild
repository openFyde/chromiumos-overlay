# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_RUST_REMOVE_DEV_DEPS=1

inherit cros-rust

DESCRIPTION="FFI bindings for libusb"
HOMEPAGE="https://docs.rs/crate/libusb1-sys/"
SRC_URI="https://crates.io/api/v1/crates/${PN}/${PV}/download -> ${P}.crate"

LICENSE="MIT"
SLOT="${PV}/${PR}"
KEYWORDS="*"

PATCHES=(
	"${FILESDIR}/${P}-0001-remove-build-dependencies.patch"
)

DEPEND="
	=dev-rust/pkg-config-0.3*:=
"
