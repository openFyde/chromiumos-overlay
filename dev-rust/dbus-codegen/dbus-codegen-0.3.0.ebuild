# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_RUST_REMOVE_DEV_DEPS=1

inherit cros-rust

DESCRIPTION="Binary crate to generate Rust code from XML introspection data."
HOMEPAGE="https://github.com/diwic/dbus-rs"
SRC_URI="https://crates.io/api/v1/crates/${PN}/${PV}/download -> ${P}.crate"

LICENSE="|| ( MIT Apache-2.0 )"
SLOT="0/${PVR}"
KEYWORDS="*"

# ansi_term-0.11.0-r0, strsim-0.8.0-r0, and vec_map-0.8.1-r0 were empty crates
# that are incompatible with this ebuild.
DEPEND="
	!=dev-rust/ansi_term-0.11.0-r0
	!=dev-rust/vec_map-0.8.1-r0
	!=dev-rust/strsim-0.8.0-r0
	>=dev-rust/clap-2.20.0:= <dev-rust/clap-3.0.0
	>=dev-rust/dbus-0.6.0:= <dev-rust/dbus-0.7.0
	>=dev-rust/xml-rs-0.3.0:= <dev-rust/xml-rs-0.4.0
"

RDEPEND="
	!<dev-rust/dbus-codegen-0.3.0-r1
"

src_compile() {
	ecargo_build
}

src_install() {
	dobin "$(cros-rust_get_build_dir)/dbus-codegen-rust"
}
