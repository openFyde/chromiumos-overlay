# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="612dee21d9c285c999cf5e1aad7b7aa3de21bbbf"
CROS_WORKON_TREE="e6eb95409eba3e6c80555f99d3a48521ca36c059"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_SUBTREE="sirenia"

START_DIR="sirenia"

inherit cros-workon cros-rust

CROS_RUST_CRATE_NAME="sirenia"
DESCRIPTION="The runtime environment and middleware for ManaTEE."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/sirenia/"

LICENSE="BSD-Google"
KEYWORDS="*"

RDEPEND=""

DEPEND="${RDEPEND}
	=dev-rust/getopts-0.2*:=
	>=dev-rust/libc-0.2.44:= <dev-rust/libc-0.3
	>=dev-rust/flexbuffers-0.1.1:= <dev-rust/flexbuffers-0.2
	dev-rust/libchromeos:=
	dev-rust/minijail:=
	>=dev-rust/openssl-0.10.22:= <dev-rust/openssl-0.11
	dev-rust/sys_util:=
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
