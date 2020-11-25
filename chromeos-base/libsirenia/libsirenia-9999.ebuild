# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_RUST_SUBDIR="sirenia/libsirenia"

CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_SUBTREE="${CROS_RUST_SUBDIR}"

inherit cros-workon cros-rust user

CROS_RUST_CRATE_NAME="libsirenia"
DESCRIPTION="The support library for the ManaTEE runtime environment."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/sirenia/libsirenia"

LICENSE="BSD-Google"
KEYWORDS="~*"
IUSE="cros_host"

RDEPEND=""

DEPEND="${RDEPEND}
	>=dev-rust/flexbuffers-0.1.1:= <dev-rust/flexbuffers-0.2
	>=dev-rust/libc-0.2.44:= <dev-rust/libc-0.3
	dev-rust/libchromeos:=
	dev-rust/minijail:=
	>=dev-rust/serde-1.0.114:= <dev-rust/serde-2
	=dev-rust/serde_derive-1*:=
	dev-rust/sys_util:=
"

src_unpack() {
	cros-workon_src_unpack
	S+="/${CROS_RUST_SUBDIR}"

	cros-rust_src_unpack
}

src_compile() {
	ecargo_build
	use test && ecargo_test --no-run
}

src_test() {
	if use x86 || use amd64; then
		ecargo_test -- --skip transport::tests::vsocktransport
	else
		elog "Skipping rust unit tests on non-x86 platform"
	fi
}
