# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="d680824e5cdfbd1fba58960a485cdd7a595ec17c"
CROS_WORKON_TREE="6b16a2fce43de96dad800600905c33ac4e578140"
CROS_RUST_SUBDIR="libchromeos-rs"

CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="../platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_SUBTREE="${CROS_RUST_SUBDIR}"

inherit cros-workon cros-rust

DESCRIPTION="A Rust utility library for Chrome OS"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/libchromeos-rs/"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="test"

DEPEND="
	dev-rust/data_model:=
	=dev-rust/dbus-0.9*:=
	=dev-rust/futures-0.3*:=
	=dev-rust/getopts-0.2*:=
	=dev-rust/intrusive-collections-0.9*:=
	>=dev-rust/lazy_static-1.4.0 <dev-rust/lazy_static-2.0.0_alpha:=
	=dev-rust/libc-0.2*:=
	=dev-rust/log-0.4*:=
	>=dev-rust/pkg-config-0.3.11 <dev-rust/pkg-config-0.4.0_alpha:=
	>=dev-rust/protobuf-2.1 <dev-rust/protobuf-3.0_alpha:=
	>=dev-rust/serde-1.0.114 <dev-rust/serde-2_alpha:=
	=dev-rust/serde_derive-1*:=
	dev-rust/sys_util:=
	dev-rust/system_api:=
	>=dev-rust/thiserror-1.0.20 <dev-rust/thiserror-2.0.0_alpha:=
	dev-rust/vboot_reference-sys:=
	>=dev-rust/zeroize-1.2.0 <dev-rust/zeroize-2.0.0_alpha:=
"

RDEPEND="${DEPEND}
	!!<=dev-rust/libchromeos-0.1.0-r2"

src_compile() {
	# Make sure the build works with default features.
	ecargo_build
	# Also check that the build works with all features.
	ecargo_build --all-features
	use test && cros-rust_src_test --no-run --all-features
}

src_test() {
	cros-rust_src_test --all-features -- --test-threads=1
}
