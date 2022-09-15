# Copyright 2020 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="1dffef3b5fa35642ed3ad2b54aa7554bf0d3ed60"
CROS_WORKON_TREE=("6807bc5be81e615ebde8ce755610cd1fd0dc2292" "2760d1ea048101782b134e43d5c1149e5e227ad2")
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

DEPEND="
	chromeos-base/crosvm-base:=
	chromeos-base/libsirenia:=
	=dev-rust/anyhow-1*
	dev-rust/chromeos-dbus-bindings:=
	=dev-rust/dbus-0.9*
	=dev-rust/getopts-0.2*
	dev-rust/libchromeos:=
	=dev-rust/log-0.4*
	=dev-rust/stderrlog-0.5*
	=dev-rust/thiserror-1*
	=dev-rust/which-4*
"
RDEPEND="${DEPEND}
	sys-apps/dbus
	sirenia? ( chromeos-base/manatee-runtime )
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
