# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="60eb1fbe89fab558bf781c6c02496a345b5d6a4c"
CROS_WORKON_TREE="dbe587d866956d88c4445de8a9380cca33c6a231"
CROS_WORKON_LOCALNAME="../platform/crosvm"
CROS_WORKON_PROJECT="chromiumos/platform/crosvm"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_SUBTREE="assertions"

inherit cros-workon cros-rust

DESCRIPTION="Crates for compile-time assertion macro."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/+/master/crosvm/assertions"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="test"

RDEPEND="!!<=dev-rust/assertions-0.1.0-r3"

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
