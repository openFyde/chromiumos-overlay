# Copyright 2022 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_RUST_REMOVE_DEV_DEPS=1

inherit cros-rust

DESCRIPTION='FFI bindings for libftdi1'
HOMEPAGE='https://github.com/tanriol/libftdi1-sys'
SRC_URI="https://crates.io/api/v1/crates/${PN}/${PV}/download -> ${P}.crate"

LICENSE="MIT"
SLOT="${PV}/${PR}"
KEYWORDS="*"

DEPEND="
	dev-rust/third-party-crates-src:=
	dev-embedded/libftdi:=
	virtual/libusb:1
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-remove-vendored.patch"
)
