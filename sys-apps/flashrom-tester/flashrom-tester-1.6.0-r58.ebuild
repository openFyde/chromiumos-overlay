# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="2e2a5e449229e9c9604235a98b56e5dd29bf25cf"
CROS_WORKON_TREE="a1f1bfef667c1166ca723e6541b723b60fe3c086"
CROS_RUST_SUBDIR="util/flashrom_tester"

CROS_WORKON_USE_VCSID="1"
CROS_WORKON_PROJECT="chromiumos/third_party/flashrom"
CROS_WORKON_EGIT_BRANCH="master"
CROS_WORKON_LOCALNAME="flashrom"
CROS_WORKON_SUBTREE="${CROS_RUST_SUBDIR}"

inherit cros-workon cros-rust

DESCRIPTION="Utility for AVL qualification of SPI flash chips with flashrom"
HOMEPAGE="https://www.flashrom.org/Flashrom"

LICENSE="GPL-2"
KEYWORDS="*"
DEPEND=">=dev-rust/rand-0.6.4:=
	=dev-rust/chrono-0.4*:=
	=dev-rust/clap-2.33*:=
	=dev-rust/libc-0.2*:=
	=dev-rust/log-0.4*:=
	=dev-rust/built-0.3*:=
	=dev-rust/sys-info-0.5.7:=
	=dev-rust/serde_json-1*:=
"

RDEPEND="!<=sys-apps/flashrom-tester-1.60-r41"

src_compile() {
	# Override HOST_CFLAGS so that build dependencies use the correct
	# flags on cross-compiled targets using cc-rs.
	tc-export_build_env
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
