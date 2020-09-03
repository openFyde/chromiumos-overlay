# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="287d6441210f03536f4c15da3d45847b3165f7da"
CROS_WORKON_TREE="5a4821ee1cf6abf2a59e48bfc7045eba4a69ae4a"
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
	>=dev-rust/serde-1.0.114:= <dev-rust/serde-2
	=dev-rust/serde_derive-1*:=
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
