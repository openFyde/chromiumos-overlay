# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="71fbf3c0e07df51c6c68a3677053d371c47e38cf"
CROS_WORKON_TREE="8df34d11e8b707d596006d273308a7bc953387a6"
CROS_WORKON_LOCALNAME="adhd"
CROS_WORKON_PROJECT="chromiumos/third_party/adhd"
CROS_WORKON_INCREMENTAL_BUILD=1
# We don't use CROS_WORKON_OUTOFTREE_BUILD here since cros_alsa/Cargo.toml
# is using "provided by ebuild" macro which supported by cros-rust
CROS_WORKON_SUBTREE="cros_alsa"

inherit cros-workon cros-rust

DESCRIPTION="Rust version alsa-lib"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/third_party/adhd/+/master/cros_alsa"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="test"

DEPEND="
	>=dev-rust/alsa-sys-0.2.0:= <dev-rust/alsa-sys-0.3.0
	>=dev-rust/libc-0.2.65:=
	<dev-rust/libc-0.3
	=dev-rust/proc-macro2-1*:=
	=dev-rust/quote-1*:=
	=dev-rust/syn-1*:=
	dev-rust/remain:=
"

src_unpack() {
	cros-workon_src_unpack
	S+="/cros_alsa"

	cros-rust_src_unpack
}

src_compile() {
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
	pushd cros_alsa_derive > /dev/null
	cros-rust_publish cros_alsa_derive "$(cros-rust_get_crate_version ${S}/cros_alsa_derive)"
	popd > /dev/null

	cros-rust_publish "${PN}" "$(cros-rust_get_crate_version)"
}

pkg_postinst() {

	cros-rust_pkg_postinst cros_alsa_derive
	cros-rust_pkg_postinst cros_alsa
}

pkg_prerm() {
	cros-rust_pkg_prerm cros_alsa_derive
	cros-rust_pkg_prerm cros_alsa
}
