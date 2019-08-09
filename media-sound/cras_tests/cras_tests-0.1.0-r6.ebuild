# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

CROS_WORKON_COMMIT="e62bd9ee13f416e00c9be2cceddb42a89a2a4d63"
CROS_WORKON_TREE="b4ea1e43784cd02a499e6b5fca7bb9492aa1321b"
CROS_WORKON_LOCALNAME="adhd"
CROS_WORKON_PROJECT="chromiumos/third_party/adhd"
# We don't use CROS_WORKON_OUTOFTREE_BUILD here since cras-sys/Cargo.toml is
# using "provided by ebuild" macro which supported by cros-rust
CROS_WORKON_SUBTREE="cras/client/cras_tests"

inherit cros-workon cros-rust

DESCRIPTION="Rust version cras test client"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/third_party/adhd/+/master/cras/client/cras_tests"

LICENSE="BSD-Google"
SLOT="${PV}/${PR}"
KEYWORDS="*"
IUSE="test"

DEPEND="
	>=dev-rust/getopts-0.2.18:=
	!>=dev-rust/getopts-0.3
	media-sound/audio_streams:=
	media-sound/libcras:=
"

src_unpack() {
	cros-workon_src_unpack
	S+="/cras/client/cras_tests"

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
	dobin "$(cros-rust_get_build_dir)/cras_tests"
}
