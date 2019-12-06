# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_WORKON_COMMIT="c8c89c6f4270b6bf7a89d54ad951a6e75204e6e7"
CROS_WORKON_TREE="24407e4bbdc45ca8a13cb8e86e45c5777b8f0739"
CROS_WORKON_LOCALNAME="adhd"
CROS_WORKON_PROJECT="chromiumos/third_party/adhd"
# We don't use CROS_WORKON_OUTOFTREE_BUILD here since cras/src/server/rust is
# using the `provided by ebuild` macro from the cros-rust eclass
CROS_WORKON_SUBTREE="cras/src/server/rust"

inherit cros-workon cros-rust

DESCRIPTION="Rust code which is used within cras"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/third_party/adhd/+/master/cras/src/server/rust"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="test"

DEPEND="
	dev-rust/libc:=
"

src_unpack() {
	cros-workon_src_unpack
	S+="/cras/src/server/rust"

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
	dolib.a "$(cros-rust_get_build_dir)/libcras_rust.a"
	cros-rust_publish "${PN}" "$(cros-rust_get_crate_version)"
}
