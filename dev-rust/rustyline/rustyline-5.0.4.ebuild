# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_RUST_REMOVE_DEV_DEPS=1

inherit cros-rust

DESCRIPTION="Rustyline, a readline implementation based on Antirez's Linenoise."
HOMEPAGE="https://docs.rs/rustyline"
SRC_URI="https://crates.io/api/v1/crates/${PN}/${PV}/download -> ${P}.crate"

LICENSE="MIT"
SLOT="${PV}/${PR}"
KEYWORDS="*"

PATCHES=( "${FILESDIR}/${PN}-${PV}-rm-dirs-feature.patch" )

DEPEND="
	>=dev-rust/dirs-2.0.0:= <dev-rust/dirs-3.0.0
	>=dev-rust/libc-0.2.0:= <dev-rust/libc-0.3.0
	>=dev-rust/log-0.4.0:= <dev-rust/log-0.5.0
	>=dev-rust/memchr-2.0.0:= <dev-rust/memchr-3.0.0
	>=dev-rust/nix-0.14.0:= <dev-rust/nix-0.15.0
	>=dev-rust/unicode-segmentation-1.0.0:= <dev-rust/unicode-segmentation-2.0.0
	>=dev-rust/unicode-width-0.1.0:= <dev-rust/unicode-width-0.2.0
	>=dev-rust/utf8parse-0.1.0:= <dev-rust/utf8parse-0.2.0
"
