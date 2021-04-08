# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="f96d9972d4d74d48a951d8448efff3590957ac04"
CROS_WORKON_TREE="38c88a14f67feae9355c5c2096dad5f59dab1934"
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_SUBTREE="ippusb_bridge"

inherit cros-workon cros-rust udev user

DESCRIPTION="A proxy for HTTP traffic over an IPP-USB printer connection"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/ippusb_bridge/"

LICENSE="BSD-Google"
SLOT="0/0"
KEYWORDS="*"
IUSE=""

COMMON_DEPEND="
	virtual/libusb:1=
"

RDEPEND="
	${COMMON_DEPEND}
	!<chromeos-base/ippusb_manager-0.0.2
"

DEPEND="
	${COMMON_DEPEND}
	>=dev-rust/chunked_transfer-1:= <dev-rust/chunked_transfer-2
	>=dev-rust/getopts-0.2.18:= <dev-rust/getopts-0.3
	>=dev-rust/httparse-1.3.4:= <dev-rust/httparse-1.4
	>=dev-rust/libc-0.2.44:= <dev-rust/libc-0.3
	>=dev-rust/rusb-0.6.2:= <dev-rust/rusb-0.7
	dev-rust/sync:=
	dev-rust/sys_util:=
	>=dev-rust/tiny_http-0.8:= <dev-rust/tiny_http-0.9
"

pkg_preinst() {
	enewgroup ippusb
	enewuser ippusb
}

src_install() {
	dobin "$(cros-rust_get_build_dir)"/ippusb_bridge

	# Install policy files.
	insinto /usr/share/policy
	newins "seccomp/ippusb-bridge-seccomp-${ARCH}.policy" \
		ippusb-bridge-seccomp.policy

	udev_dorules udev/*.rules

	insinto /etc/init
	newins "init/ippusb-bridge.conf" "ippusb-bridge.conf"

	exeinto /usr/libexec/ippusb
	doexe "init/bridge_start"
	doexe "init/bridge_stop"
}
