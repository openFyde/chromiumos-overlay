# Copyright 2021 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_RUST_REMOVE_DEV_DEPS=1

inherit cros-rust

DESCRIPTION='Generate Rust register maps ("struct"s) from SVD files'
HOMEPAGE='https://crates.io/crates/svd2rust'
SRC_URI="https://crates.io/api/v1/crates/${PN}/${PV}/download -> ${P}.crate"

LICENSE="|| ( MIT Apache-2.0 )"
SLOT="${PV}/${PR}"
KEYWORDS="*"

DEPEND="
	=dev-rust/anyhow-1*
	=dev-rust/cast-0.3*
	>=dev-rust/clap-2.33.0 <dev-rust/clap-3.0.0_alpha
	>=dev-rust/clap_conf-0.1.5 <dev-rust/clap_conf-0.2.0_alpha
	=dev-rust/env_logger-0.9*
	>=dev-rust/inflections-1.1.0 <dev-rust/inflections-2.0.0_alpha
	=dev-rust/log-0.4*
	=dev-rust/proc-macro2-1*
	=dev-rust/quote-1*
	=dev-rust/svd-parser-0.12*
	=dev-rust/syn-1*
	=dev-rust/thiserror-1*
"
RDEPEND="${DEPEND}"

src_compile() {
	ecargo_build
	use test && ecargo_test --no-run
}

src_install() {
	dobin "${CARGO_TARGET_DIR}/${CHOST}/release/svd2rust"
}

src_configure() {
	cros-rust_src_configure

	# svd2rust uses proc-macro2, which decides at runtime whether to use
	# rustc's proc-macro based on whether calling it panics or not. i.e. it
	# uses std::panic::catch_unwind. This means that it aborts if panic=abort.
	# The latest version of proc-macro2 fixes this, provided rustc is >=
	# 1.57.0. So we can return to using panic=abort once we have updated to
	# 1.57.0 or later and updated proc-macro2.
	sed -i -e 's/panic=abort/panic=unwind/' "${CARGO_HOME}/config" || die
}
