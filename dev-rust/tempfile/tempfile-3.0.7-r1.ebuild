# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

CROS_WORKON_COMMIT="e33b55c4298c8f0d3dff7f04343e765559463d3a"
CROS_WORKON_TREE="341ba6f8da2119d20d1d23e677b4c8d7fdf1358b"
CROS_WORKON_LOCALNAME="../platform/crosvm"
CROS_WORKON_PROJECT="chromiumos/platform/crosvm"
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_SUBTREE="tempfile"

inherit cros-workon cros-rust

DESCRIPTION="A library for managing temporary files and directories"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/+/master/crosvm/tempfile"

LICENSE="BSD-Google"
SLOT="${PV}/${PR}"
KEYWORDS="*"
IUSE="test"

DEPEND="
	=dev-rust/cfg-if-0.1*:=
	>=dev-rust/libc-0.2.27:=
	=dev-rust/rand-0.6*:=
	=dev-rust/redox_syscall-0.1*:=
	=dev-rust/remove_dir_all-0.5*:=
	=dev-rust/winapi-0.3*:=
"

src_unpack() {
	cros-workon_src_unpack
	S+="/tempfile"

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
