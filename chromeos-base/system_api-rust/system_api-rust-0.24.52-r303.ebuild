# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="05551a93df1478936dc33dfe506fb7ce1c7b70c1"
CROS_WORKON_TREE=("a0d8550678a1ed2a4ab62782049032a024bf40df" "bf5e7ad44dfa26d1ba76610a42acec3d33aa31b8" "d289fda3c8ee1448b8cdf3425062327cde39dd8c" "1c0134acec54918b28b197172bc2df2ce87174ac")
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_SUBTREE="authpolicy/dbus_bindings debugd/dbus_bindings login_manager/dbus_bindings system_api"

START_DIR="system_api"

inherit cros-workon cros-rust

CROS_RUST_CRATE_NAME="system_api"
DESCRIPTION="Chrome OS system API D-Bus bindings for Rust."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/system_api/"

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
