# Copyright 2021 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_RUST_REMOVE_DEV_DEPS=1
CROS_RUST_REMOVE_TARGET_CFG=1

inherit cros-rust

DESCRIPTION='FFI bindings for libusb.'
HOMEPAGE='https://github.com/a1ien/libusb1-sys'
SRC_URI="https://crates.io/api/v1/crates/${PN}/${PV}/download -> ${P}.crate"

LICENSE="MIT"
SLOT="${PV}/${PR}"
KEYWORDS="*"

DEPEND="
	dev-rust/third-party-crates-src:=
	virtual/libusb:1
"
RDEPEND="${DEPEND}"

src_prepare() {
	cros-rust_src_prepare

	# Remove bundled libusb sources. This breaks the 'vendored' feature of this
	# crate, which should not be used in Chromium OS. We want to link against
	# the system copy of libusb.
	rm -r libusb
}
