# Copyright 2020 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="70ada8046be10beb4d17680c6054b0e84db433c4"
CROS_WORKON_TREE=("95855e9a8ea4ff2cf2e22058561fa38c51bcbe0a" "2760d1ea048101782b134e43d5c1149e5e227ad2")
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
	dev-rust/third-party-crates-src:=
	chromeos-base/crosvm-base:=
	chromeos-base/libsirenia:=
	dev-rust/chromeos-dbus-bindings:=
	dev-rust/libchromeos:=
	sys-apps/dbus:=
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
