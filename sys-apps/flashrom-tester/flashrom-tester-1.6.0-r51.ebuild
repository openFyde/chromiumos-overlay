# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="41785f6be311d2e9f4ba0d61319e7fcab95f2f70"
CROS_WORKON_TREE="f50db9b74456fdaa0c71ae49ce9d07fc21047583"
CROS_WORKON_USE_VCSID="1"
CROS_WORKON_PROJECT="chromiumos/third_party/flashrom"
CROS_WORKON_LOCALNAME="flashrom"
CROS_WORKON_SUBTREE="util/flashrom_tester"
CROS_WORKON_SUBDIRS_TO_COPY="util/flashrom_tester"

inherit cros-workon cros-rust

DESCRIPTION="Utility for AVL qualification of SPI flash chips with flashrom"
HOMEPAGE="https://www.flashrom.org/Flashrom"

LICENSE="GPL-2"
KEYWORDS="*"
DEPEND=">=dev-rust/rand-0.6.4:=
	=dev-rust/chrono-0.4*:=
	=dev-rust/clap-2.33*:=
	=dev-rust/log-0.4*:=
	=dev-rust/built-0.3*:=
	=dev-rust/sys-info-0.5.7:=
	=dev-rust/serde_json-1*:=
"

RDEPEND="!<=sys-apps/flashrom-tester-1.60-r41"

src_unpack() {
	cros-workon_src_unpack
	S=$S/$CROS_WORKON_SUBTREE
	cros-rust_src_unpack
}

src_compile() {
	# Override HOST_CFLAGS so that build dependencies use the correct
	# flags on cross-compiled targets using cc-rs.
	tc-export_build_env
	export HOST_CFLAGS="${BUILD_CFLAGS}"
	ecargo_build
	if use test; then
		ecargo_test --no-run
		ecargo_test --no-run -p flashrom
	fi
}

src_test() {
	if use x86 || use amd64; then
		ecargo_test
		ecargo_test -p flashrom
	else
		elog "Skipping rust unit tests on non-x86 platform"
	fi
}

src_install() {
	dobin "$(cros-rust_get_build_dir)/flashrom_tester"
}
