# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CROS_WORKON_COMMIT="467467e6900b16ba8edd09704d27d3f4e5d3acc9"
CROS_WORKON_TREE=("a0d8550678a1ed2a4ab62782049032a024bf40df" "b3e07bffb7b727e2240fc4393daf01ee76b606b2" "ba15d6389975ee3f002088a3e5f8ba186dcc24d7" "81fc17f8d75cbfa6d0ca7f2baa40a2c5769b1e9c")
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_SUBTREE="authpolicy/dbus_bindings debugd/dbus_bindings login_manager/dbus_bindings system_api"

START_DIR="system_api"

inherit cros-workon cros-rust

RUST_CRATE="system_api"
DESCRIPTION="Chrome OS system API D-Bus bindings for Rust."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/system_api/"

LICENSE="BSD-Google"
SLOT="0/${PVR}"
KEYWORDS="*"

RDEPEND=""

DEPEND="${RDEPEND}
	chromeos-base/chromeos-dbus-bindings-rust:=
	=dev-rust/dbus-0.6*:=
"

src_unpack() {
	cros-workon_src_unpack
	S+="/${START_DIR}"

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
	cros-rust_publish "${RUST_CRATE}" "$(cros-rust_get_crate_version)"
}

pkg_postinst() {
	cros-rust_pkg_postinst "${RUST_CRATE}"
}

pkg_prerm() {
	cros-rust_pkg_prerm "${RUST_CRATE}"
}
