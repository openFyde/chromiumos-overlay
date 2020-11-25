# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="81e746da7567122cfb8465ee1d7796b3cc5c077a"
CROS_WORKON_TREE="25733f7ca89671526a2eab2cd6a7a863730b8d4f"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_SUBTREE="sirenia"

START_DIR="sirenia"

inherit cros-workon cros-rust user

CROS_RUST_CRATE_NAME="sirenia"
DESCRIPTION="The runtime environment and middleware for ManaTEE."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/sirenia/"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="cros_host"

RDEPEND=""

DEPEND="${RDEPEND}
	>chromeos-base/chromeos-dbus-bindings-rust-0.24.52-r16:=
	=dev-rust/chrono-0.4*:=
	=dev-rust/dbus-0.8*:=
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
# We skip the vsock test because it requires the vsock kernel modules to be
# loaded.
src_test() {
	if use x86 || use amd64; then
		ecargo_test -- --skip transport::tests::vsocktransport
	else
		elog "Skipping rust unit tests on non-x86 platform"
	fi
}

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
