# Copyright 2020 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cros-rust

DESCRIPTION="FFI bindings for the ALSA project (Advanced Linux Sound Architecture)"
HOMEPAGE="https://docs.rs/alsa-sys"
SRC_URI="https://crates.io/api/v1/crates/${PN}/${PV}/download -> ${P}.crate"

LICENSE="MIT"
SLOT="${PV}/${PR}"
KEYWORDS="*"

DEPEND="
	dev-rust/third-party-crates-src:=
	>=media-libs/alsa-lib-1.1.8-r3:= <media-libs/alsa-lib-2.0.0
"
