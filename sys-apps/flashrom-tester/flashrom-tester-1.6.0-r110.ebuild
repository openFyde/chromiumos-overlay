# Copyright 2019 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="64a7c1d2f75a717c47aeb3edb4d2bba73d7b36ac"
CROS_WORKON_TREE=("c89ac976c0cd028624fce58deb6ba55c366141ca" "56c8acb0cc6d8a4d0cab33551a283a6ee495620c" "b33bb3b65dfb8b92a68e103fbccedc8f27cfabdf" "2e2d7a209735e7d06b8c52e2d5586b982edf7c39")
CROS_RUST_SUBDIR="util/flashrom_tester"

CROS_WORKON_USE_VCSID="1"
CROS_WORKON_PROJECT="chromiumos/third_party/flashrom"
CROS_WORKON_EGIT_BRANCH="master"
CROS_WORKON_LOCALNAME="flashrom"
CROS_WORKON_SUBTREE="${CROS_RUST_SUBDIR} bindings/rust/libflashrom bindings/rust/libflashrom-sys include"

inherit cros-workon cros-rust

DESCRIPTION="Utility for AVL qualification of SPI flash chips with flashrom"
HOMEPAGE="https://www.flashrom.org/Flashrom"

LICENSE="GPL-2"
KEYWORDS="*"
DEPEND="
	dev-rust/third-party-crates-src:=
	sys-apps/flashrom
"

RDEPEND="!<=sys-apps/flashrom-tester-1.60-r41
	sys-apps/flashrom
"

BDEPEND=""

src_compile() {
	# Override HOST_CFLAGS so that build dependencies use the correct
	# flags on cross-compiled targets using cc-rs.
	tc-export_build_env
	# ignore missing BUILD_CFLAGS definition lint
	# shellcheck disable=2154
	export HOST_CFLAGS="${BUILD_CFLAGS}"
	ecargo_build
	if use test; then
		ecargo_test --no-run --workspace
	fi
}

src_test() {
	cros-rust_src_test --workspace
}

src_install() {
	dobin "$(cros-rust_get_build_dir)/flashrom_tester"
}
