# Copyright 2019 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_RUST_SUBDIR="libchromeos-rs"

CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="../platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_SUBTREE="${CROS_RUST_SUBDIR}"

inherit cros-workon cros-rust

DESCRIPTION="A Rust utility library for Chrome OS"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/libchromeos-rs/"

LICENSE="BSD-Google"
KEYWORDS="~*"
IUSE="test"

DEPEND="
	dev-rust/third-party-crates-src:=
	chromeos-base/crosvm-base:=
	=dev-rust/dbus-0.9*
	=dev-rust/lazy_static-1*
	=dev-rust/log-0.4*
	=dev-rust/multi_log-0.1*
	=dev-rust/stderrlog-0.5*
	=dev-rust/syslog-6*
	dev-rust/system_api:=
	dev-rust/vboot_reference-sys:=
	=dev-rust/zeroize-1*
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
