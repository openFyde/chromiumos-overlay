# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="08292877545b957133aae32ddecb7eb787598c40"
CROS_WORKON_TREE="bf714bb05e07ad69b6003c114a17b4b30135a295"
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_SUBTREE="ippusb_bridge"

inherit cros-workon cros-rust

DESCRIPTION="A proxy for HTTP traffic over an IPP-USB printer connection"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/ippusb_bridge/"

LICENSE="BSD-Google"
SLOT="0/0"
KEYWORDS="*"
IUSE=""

COMMON_DEPEND="
	virtual/libusb:1=
"

RDEPEND="${COMMON_DEPEND}"

DEPEND="
	${COMMON_DEPEND}
	>=dev-rust/chunked_transfer-1:= <dev-rust/chunked_transfer-2
	>=dev-rust/getopts-0.2.18:= <dev-rust/getopts-0.3
	>=dev-rust/httparse-1.3.4:= <dev-rust/httparse-1.4
	>=dev-rust/libc-0.2.44:= <dev-rust/libc-0.3
	>=dev-rust/rusb-0.6.2:= <dev-rust/rusb-0.7
	dev-rust/sync:=
	dev-rust/sys_util:=
	>=dev-rust/tiny_http-0.7:= <dev-rust/tiny_http-0.8
"

src_unpack() {
	cros-workon_src_unpack
	S+="/ippusb_bridge"

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
	dobin "$(cros-rust_get_build_dir)"/ippusb_bridge

	# Install policy files.
	insinto /usr/share/policy
	newins "seccomp/ippusb-bridge-seccomp-${ARCH}.policy" \
		ippusb-bridge-seccomp.policy
}
