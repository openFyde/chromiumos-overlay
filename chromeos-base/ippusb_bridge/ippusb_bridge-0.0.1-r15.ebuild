# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="2340c78a8f7bd7607a20ab406a049f2ad572a966"
CROS_WORKON_TREE="9798835a72e150e6a94e1dea2179b6766bb03e3d"
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

src_install() {
	dobin "$(cros-rust_get_build_dir)"/ippusb_bridge

	# Install policy files.
	insinto /usr/share/policy
	newins "seccomp/ippusb-bridge-seccomp-${ARCH}.policy" \
		ippusb-bridge-seccomp.policy
}
