# Copyright 2021 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_RUST_REMOVE_DEV_DEPS=1

inherit cros-rust

DESCRIPTION="A VK-GL-CTS/dEQP wrapper program to parallelize it across CPUs and report results against a baseline."
HOMEPAGE="https://gitlab.freedesktop.org/anholt/deqp-runner"
SRC_URI="https://crates.io/api/v1/crates/${PN}/${PV}/download -> ${P}.crate"

LICENSE="MIT"
SLOT="0/${PR}"
KEYWORDS="*"

DEPEND="
	dev-rust/third-party-crates-src:=
	=dev-rust/anyhow-1*
	>=dev-rust/crossbeam-utils-0.8 <dev-rust/crossbeam-utils-0.9
	>=dev-rust/flate2-1.0.18 <dev-rust/flate2-2
	=dev-rust/junit-report-0.4*
	>=dev-rust/rand-0.7.3 <dev-rust/rand-0.8
	>=dev-rust/rayon-1.5.0 <dev-rust/rayon-2.0.0
	>=dev-rust/stderrlog-0.4 <dev-rust/stderrlog-0.6
	=dev-rust/structopt-0.3*
	=dev-rust/toml-0.5*
"

src_compile() {
	ecargo_build
}

src_install() {
	local build_dir="$(cros-rust_get_build_dir)"

	dobin "${build_dir}/deqp-runner"
}
