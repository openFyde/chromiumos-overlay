# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CROS_WORKON_COMMIT="b52c0b532f027280ba0864db55d41a61348188d2"
CROS_WORKON_TREE=("a0d8550678a1ed2a4ab62782049032a024bf40df" "b20be988d0cf1afa89dcd284073ce46e3e30987d" "d992bed91f26f4f682bc172aacaa731e70ad443f" "b8090a14f830fe3c69de2b89518d0f5c9e30b6be")
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
