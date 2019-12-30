# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_WORKON_COMMIT="946cb260d07c9638f933b967b126397b452a8cd0"
CROS_WORKON_TREE="bb3e7600f3cbe23b995ab47d5c19f547aad1cb04"
CROS_WORKON_LOCALNAME="adhd"
CROS_WORKON_PROJECT="chromiumos/third_party/adhd"
# We don't use CROS_WORKON_OUTOFTREE_BUILD here since cras-sys/Cargo.toml is
# using "provided by ebuild" macro which supported by cros-rust
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_SUBTREE="cras/client/libcras"

inherit cros-workon cros-rust

DESCRIPTION="Rust version libcras"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/third_party/adhd/+/master/cras/client/libcras"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="test"

DEPEND="
	>=dev-rust/libc-0.2.44:=
	dev-rust/data_model:=
	dev-rust/sys_util:=
	dev-rust/sync:=
	media-sound/audio_streams:=
	media-sound/cras-sys:=
"

RDEPEND="!<=media-sound/libcras-0.1.0-r21"

src_unpack() {
	cros-workon_src_unpack
	S+="/cras/client/libcras"

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
