# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_WORKON_COMMIT="645ad21dee6be08fe9ead50e1ce8db4b60724384"
CROS_WORKON_TREE="76209c09de86847598f3b5a4ac649bb9ab7a4e25"
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
