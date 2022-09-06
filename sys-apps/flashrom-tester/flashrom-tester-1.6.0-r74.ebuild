# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="60b908e39df4542c4c8e4400ef1c329d304b326f"
CROS_WORKON_TREE=("0fcda7dc7c435c43cdc7f1a9be1a0b7d9ed03bfe" "56c8acb0cc6d8a4d0cab33551a283a6ee495620c" "b33bb3b65dfb8b92a68e103fbccedc8f27cfabdf" "23fe9ae6c8c9ce0296adf8ce34f63fb60635c37e")
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
DEPEND="=dev-rust/rand-0.6*:=
	=dev-rust/chrono-0.4*:=
	=dev-rust/clap-2.33*:=
	=dev-rust/libc-0.2*:=
	=dev-rust/log-0.4*:=
	=dev-rust/built-0.5*:=
	~dev-rust/sys-info-0.9.1:=
	=dev-rust/serde_json-1*:=
"

RDEPEND="!<=sys-apps/flashrom-tester-1.60-r41
	sys-apps/flashrom
"

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
