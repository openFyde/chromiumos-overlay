# Copyright 2021 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_RUST_REMOVE_DEV_DEPS=1

inherit cros-rust

DESCRIPTION='Algorithms for demosaicing Bayer images.'
HOMEPAGE='https://github.com/wangds/libbayer.git'
SRC_URI="https://crates.io/api/v1/crates/${PN}/${PV}/download -> ${P}.crate"

LICENSE="MIT"
SLOT="${PV}/${PR}"
KEYWORDS="*"

DEPEND="
	dev-rust/third-party-crates-src:=
	=dev-rust/libc-0.2*
	>=dev-rust/quick-error-1.2.0 <dev-rust/quick-error-2.0.0_alpha
	=dev-rust/rayon-0.8*
"
RDEPEND="${DEPEND}"

RESTRICT="test"

src_prepare() {
	cros-rust_src_prepare

	# Cargo.toml has:
	#   crate-type = ["rlib", "dylib"]
	# so that this crate can be used as a normal Rust library or as a DSO from
	# other languages. But that confuses cargo when it tries to use this crate
	# in an executable, like hps-mon, because it thinks we want to link this
	# crate as a dylib instead of an rlib:
	# 	error: cannot prefer dynamic linking when performing LTO
	# 	note: only 'staticlib', 'bin', and 'cdylib' outputs are supported with LTO
	# Since nothing uses the DSO from this crate, and we aren't packaging it,
	# just hack Cargo.toml to make this into a normal Rust library.
	sed -i -e '/crate-type = /d' Cargo.toml
}
