# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CROS_WORKON_COMMIT="8428ad2b1a0c14dd4cd5cf4da7a8930e1d193f6c"
CROS_WORKON_TREE="b11fcaf9bded41b51d0405ea99b74ca107667430"
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
