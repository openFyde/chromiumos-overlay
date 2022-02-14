# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="37ea5153cd2bf86fce8aee3213b0d4c63a323c68"
CROS_WORKON_TREE=("a45d74935ed8a1b416a2704f61f7b0db2709db63" "25a1ae7cda68dd556be3abce89032e8c2298d5c4")
CROS_RUST_SUBDIR="sirenia/manatee-client"

CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="../platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_SUBTREE="${CROS_RUST_SUBDIR} sirenia/dbus_bindings"

inherit cros-workon cros-rust

DESCRIPTION="Rust D-Bus bindings for ManaTEE."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/sirenia/manatee-client"

LICENSE="BSD-Google"
SLOT="0/${PVR}"
KEYWORDS="*"
IUSE="sirenia"

RDEPEND="
	sys-apps/dbus
	sirenia? ( chromeos-base/manatee-runtime )
"
DEPEND="${RDEPEND}
	chromeos-base/libsirenia:=
	=dev-rust/anyhow-1*:=
	dev-rust/chromeos-dbus-bindings:=
	=dev-rust/dbus-0.9*:=
	=dev-rust/getopts-0.2*:=
	dev-rust/libchromeos:=
	=dev-rust/log-0.4*:=
	=dev-rust/stderrlog-0.5*:=
	dev-rust/sys_util:=
	>=dev-rust/termion-1.5.0 <dev-rust/termion-2.0.0:=
	>=dev-rust/thiserror-1.0.20:= <dev-rust/thiserror-2.0
	=dev-rust/which-4*:=
"

BDEPEND="sirenia? ( chromeos-base/sirenia-tools )"

src_compile() {
	cros-rust_src_compile --all-features
}

src_test() {
	cros-rust_src_test --all-features
}

src_install() {
	cros-rust_src_install

	local build_dir="$(cros-rust_get_build_dir)"
	dobin "${build_dir}/manatee"

	# The final app manifest is ordinarily stored on the ManaTEE initramfs.
	# For development convenience, we put in on rootfs for non-manatee
	# builds.
	if use sirenia ; then
		local APP_MANIFESTS=( "${SYSROOT}/usr/share/manatee/templates/"*.json )
		dodir /usr/share/manatee
		tee_app_info_lint -R "${SYSROOT}" -o "${D}/usr/share/manatee/manatee.flex.bin" "${APP_MANIFESTS[@]}" || die
	fi
}
