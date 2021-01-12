# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="e2ae0b1627d081187ae2cb21c1b76663a1d9eab4"
CROS_WORKON_TREE="df2c19452d483d533eaac00f8e1f845e09fa5d82"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_SUBTREE="sirenia"

inherit cros-workon cros-rust user

DESCRIPTION="The runtime environment and middleware for ManaTEE."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/sirenia/"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="cros_host"

RDEPEND="sys-apps/dbus"

DEPEND="${RDEPEND}
	chromeos-base/libsirenia:=
	=dev-rust/chrono-0.4*:=
	dev-rust/chromeos-dbus-bindings:=
	=dev-rust/dbus-0.8*:=
	=dev-rust/getopts-0.2*:=
	dev-rust/libchromeos:=
	>=dev-rust/serde-1.0.114:= <dev-rust/serde-2
	=dev-rust/serde_derive-1*:=
	dev-rust/sync:=
	dev-rust/sys_util:=
	>=dev-rust/thiserror-1.0.20:= <dev-rust/thiserror-2.0
"

src_install() {
	local build_dir="$(cros-rust_get_build_dir)"
	dobin "${build_dir}/dugong"

	insinto /etc/dbus-1/system.d
	doins dbus/org.chromium.ManaTEE.conf

	# Needed for initramfs, but not for the root-fs.
	if use cros_host ; then
		# /build is not allowed when installing to the host.
		exeinto "/bin"
	else
		exeinto "/build/initramfs"
	fi
	doexe "${build_dir}/trichechus"
}

pkg_setup() {
	enewuser dugong
	enewgroup dugong
	cros-rust_pkg_setup
}
