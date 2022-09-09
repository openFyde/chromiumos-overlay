# Copyright 2020 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_SUBTREE="ippusb_bridge"

inherit cros-workon cros-rust udev user

DESCRIPTION="A proxy for HTTP traffic over an IPP-USB printer connection"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/ippusb_bridge/"

LICENSE="BSD-Google"
SLOT="0/0"
KEYWORDS="~*"
IUSE=""

COMMON_DEPEND="
	virtual/libusb:1=
"

RDEPEND="
	${COMMON_DEPEND}
	!chromeos-base/ippusb_manager
"

DEPEND="
	${COMMON_DEPEND}
	>=dev-rust/chunked_transfer-1 <dev-rust/chunked_transfer-2
	>=dev-rust/getopts-0.2.18 <dev-rust/getopts-0.3
	>=dev-rust/httparse-1.3.4 <dev-rust/httparse-1.4
	>=dev-rust/libc-0.2.44 <dev-rust/libc-0.3
	>=dev-rust/rusb-0.8.1 <dev-rust/rusb-0.9
	dev-rust/sync:=
	dev-rust/sys_util:=
	>=dev-rust/tiny_http-0.8 <dev-rust/tiny_http-0.9
"

pkg_preinst() {
	enewgroup ippusb
	enewuser ippusb

	cros-rust_pkg_preinst
}

src_install() {
	dobin "$(cros-rust_get_build_dir)"/ippusb_bridge

	# install tmpfiles.d
	insinto /usr/lib/tmpfiles.d/on-demand/
	newins "tmpfiles.d/on-demand/ippusb-bridge.conf" "ippusb-bridge.conf"

	# Install policy files.
	insinto /usr/share/policy
	newins "seccomp/ippusb-bridge-seccomp-${ARCH}.policy" \
		ippusb-bridge-seccomp.policy

	udev_dorules udev/*.rules

	insinto /etc/init
	newins "init/ippusb-bridge.conf" "ippusb-bridge.conf"

	insinto /usr/share/ippusb_bridge
	newins "init/ippusb-bridge-debug.conf" "ippusb-bridge-debug.conf"

	exeinto /usr/libexec/ippusb
	doexe "init/bridge_start"
	doexe "init/bridge_stop"
}
