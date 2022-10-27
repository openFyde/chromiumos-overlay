# Copyright 2021 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_RUST_REMOVE_DEV_DEPS=1

inherit cros-rust

DESCRIPTION='Binary crate to generate Rust code from XML introspection data'
HOMEPAGE='https://crates.io/crates/dbus-codegen'
SRC_URI="https://crates.io/api/v1/crates/${PN}/${PV}/download -> ${P}.crate"

LICENSE="|| ( Apache-2.0 MIT )"
SLOT="0/${PVR}"
KEYWORDS="*"

DEPEND="
	dev-rust/third-party-crates-src:=
	=dev-rust/dbus-0.9*
	=dev-rust/dbus-crossroads-0.5*
	=dev-rust/dbus-tree-0.9*
"
RDEPEND="${DEPEND}"


src_compile() {
	ecargo_build
}

src_install() {
	dobin "$(cros-rust_get_build_dir)/dbus-codegen-rust"
}
