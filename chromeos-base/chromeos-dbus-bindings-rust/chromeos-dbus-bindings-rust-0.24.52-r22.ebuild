# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="81e746da7567122cfb8465ee1d7796b3cc5c077a"
CROS_WORKON_TREE="e07dc39dd87d5d07486bb506c6b6f0ebcf76d0d4"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_SUBTREE="chromeos-dbus-bindings"

inherit cros-workon cros-rust

CROS_RUST_CRATE_NAME="chromeos_dbus_bindings"
DESCRIPTION="Chrome OS D-Bus bindings generator for Rust."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/chromeos-dbus-bindings/"

LICENSE="BSD-Google"
SLOT="0/${PVR}"
KEYWORDS="*"

BDEPEND=">=dev-rust/dbus-codegen-0.5.0"

src_unpack() {
	cros-workon_src_unpack
	S+="/${CROS_WORKON_SUBTREE}"

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
