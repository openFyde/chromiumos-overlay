# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="bb662be7e5f24f0d2d61b8e655c4cd358356f06e"
CROS_WORKON_TREE="cc72be195ede90b09a9ae394923ac01be3ce4081"
CROS_WORKON_PROJECT="chromiumos/third_party/tlsdate"
CROS_WORKON_LOCALNAME="tlsdate"

inherit cros-workon cros-rust

DESCRIPTION="Rust D-Bus bindings for tlsdate."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/third_party/tlsdate/+/master/"

LICENSE="BSD-Google"
SLOT="0/${PVR}"
KEYWORDS="*"

RDEPEND=""

DEPEND="${RDEPEND}
	>chromeos-base/chromeos-dbus-bindings-rust-0.24.52-r16:=
	=dev-rust/dbus-0.8*:=
"

src_unpack() {
	cros-workon_src_unpack
	cros-rust_src_unpack
}

src_compile() {
	ecargo_build
	use test && ecargo_test --no-run
}

src_test() {
	if use x86 || use amd64; then
		ecargo_test
	else
		elog "Skipping rust unit tests on non-x86 platform"
	fi
}

src_install() {
	cros-rust_publish "${PN}" "$(cros-rust_get_crate_version)"
}
