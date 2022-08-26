# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="bd6d9b39c1093433b95d6ee3ece809f2ed12a2ce"
CROS_WORKON_TREE="2863c6a8055055d2655845884c1ed209f785b3ad"
CROS_WORKON_LOCALNAME="adhd"
CROS_WORKON_PROJECT="chromiumos/third_party/adhd"
CROS_WORKON_INCREMENTAL_BUILD=1
# We don't use CROS_WORKON_OUTOFTREE_BUILD here since cros_alsa/Cargo.toml
# is using "provided by ebuild" macro which supported by cros-rust
CROS_WORKON_SUBTREE="cros_alsa"

inherit cros-workon cros-rust

DESCRIPTION="Rust version alsa-lib"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/third_party/adhd/+/HEAD/cros_alsa"

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
	dev-rust/sys_util:=
	dev-rust/remain:=
"
# (crbug.com/1182669): build-time only deps need to be in RDEPEND so they are pulled in when
# installing binpkgs since the full source tree is required to use the crate.
RDEPEND="${DEPEND}"

pkg_setup() {
	cros-rust_pkg_setup cros_alsa_derive
	cros-rust_pkg_setup cros_alsa
}

src_compile() {
	(
		cd cros_alsa_derive || die
		cros-rust_src_compile
	)

	cros-rust_src_compile
}

src_test() {
	(
		cd cros_alsa_derive || die
		cros-rust_src_test
	)

	cros-rust_src_test
}

src_install() {
	(
		cd cros_alsa_derive || die
		cros-rust_publish cros_alsa_derive "$(cros-rust_get_crate_version .)"
	)

	cros-rust_publish "${PN}" "$(cros-rust_get_crate_version)"
}

pkg_preinst() {
	cros-rust_pkg_preinst cros_alsa_derive
	cros-rust_pkg_preinst cros_alsa
}

pkg_postinst() {
	cros-rust_pkg_postinst cros_alsa_derive
	cros-rust_pkg_postinst cros_alsa
}

pkg_prerm() {
	cros-rust_pkg_prerm cros_alsa_derive
	cros-rust_pkg_prerm cros_alsa
}
