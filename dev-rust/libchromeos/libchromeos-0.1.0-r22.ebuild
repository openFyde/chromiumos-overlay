# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="e9db463c26e871e2c58616541f7e8f1dce1a532f"
CROS_WORKON_TREE="381a389c15c3898810ef372d214fe56b4b132d9b"
CROS_WORKON_LOCALNAME="../platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_SUBTREE="libchromeos-rs"

inherit cros-workon cros-rust

DESCRIPTION="A Rust utility library for Chrome OS"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/libchromeos-rs/"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="test"

DEPEND="chromeos-base/system_api:=
	sys-apps/dbus:=
	dev-rust/data_model:=
	=dev-rust/futures-0.3*:=
	=dev-rust/getopts-0.2*:=
	=dev-rust/intrusive-collections-0.9*:=
	=dev-rust/libc-0.2*:=
	=dev-rust/log-0.4*:=
	>=dev-rust/protobuf-2.1:=
	!>=dev-rust/protobuf-3.0:=
"

RDEPEND="!!<=dev-rust/libchromeos-0.1.0-r2"

src_unpack() {
	cros-workon_src_unpack
	S+="/libchromeos-rs"

	cros-rust_src_unpack
}

src_compile() {
	use test && ecargo_test --no-run
}

src_test() {
	if ! use x86 && ! use amd64 ; then
		elog "Skipping unit tests on non-x86 platform"
	else
		ecargo_test
	fi
}

src_install() {
	cros-rust_publish "${PN}" "$(cros-rust_get_crate_version)"
}
