# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# TODO(crbug.com/1157860) Enable non x86_64 tests.
CROS_WORKON_COMMIT="f094baa9d7bb1c2b87a13cdceb6c02b376ddfa50"
CROS_WORKON_TREE="8c5acbb648eddadb38f484cd84bba08d5be5a834"
CROS_RUST_TEST_DIRECT_EXEC_ONLY="yes"
CROS_RUST_SUBDIR="libchromeos-rs"

CROS_WORKON_LOCALNAME="../platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_SUBTREE="${CROS_RUST_SUBDIR}"

inherit cros-workon cros-rust

DESCRIPTION="A Rust utility library for Chrome OS"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/libchromeos-rs/"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="test"

COMMON_DEPEND="chromeos-base/vboot_reference:="

DEPEND="${COMMON_DEPEND}
	dev-rust/data_model:=
	=dev-rust/futures-0.3*:=
	=dev-rust/getopts-0.2*:=
	=dev-rust/intrusive-collections-0.9*:=
	=dev-rust/libc-0.2*:=
	=dev-rust/log-0.4*:=
	>=dev-rust/pkg-config-0.3.11:= <dev-rust/pkg-config-0.4.0:=
	>=dev-rust/protobuf-2.1:= !>=dev-rust/protobuf-3.0:=
	dev-rust/system_api:=
	>=dev-rust/thiserror-1.0.20:= <dev-rust/thiserror-2.0.0
"

RDEPEND="${COMMON_DEPEND}
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
