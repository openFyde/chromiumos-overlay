# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

CROS_WORKON_COMMIT="d41d726c2f977789fdd3f6cd701f0c7616b778ac"
CROS_WORKON_TREE="1ac3712cd12c6a37afae751bc9b17cd6906e6681"
CROS_WORKON_LOCALNAME="../platform/crosvm"
CROS_WORKON_PROJECT="chromiumos/platform/crosvm"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_SUBTREE="assertions"

inherit cros-workon cros-rust

DESCRIPTION="Crates for compile-time assertion macro."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/+/master/crosvm/assertions"

LICENSE="BSD-Google"
SLOT="${PV}/${PR}"
KEYWORDS="*"
IUSE="test"

src_unpack() {
	cros-workon_src_unpack
	S+="/assertions"

	cros-rust_src_unpack
}

src_compile() {
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
