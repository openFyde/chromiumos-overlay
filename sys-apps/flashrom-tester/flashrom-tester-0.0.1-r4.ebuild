# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

CROS_WORKON_COMMIT="683b2d082dbe8d8e80d8657b8bd1791824902bbb"
CROS_WORKON_TREE="9536fb6efa31aecf7f50923007f2a2755a3abef0"
CROS_WORKON_PROJECT="chromiumos/third_party/flashrom"
CROS_WORKON_LOCALNAME="flashrom"
CROS_WORKON_SUBTREE="util/flashrom_tester"
CROS_WORKON_SUBDIRS_TO_COPY="util/flashrom_tester"

inherit cros-workon cros-rust

DESCRIPTION="Utility for AVL qualification of SPI flash chips with flashrom"
HOMEPAGE="https://www.flashrom.org/Flashrom"

LICENSE="GPL-2"
SLOT="${PV}/${PR}"
KEYWORDS="*"
DEPEND=">=dev-rust/rand-0.6.4:=
	=dev-rust/chrono-0.4*:=
	=dev-rust/log-0.4*:=
	=dev-rust/env_logger-0.6.1:=
	=dev-rust/built-0.3*:=
	=dev-rust/sys-info-0.5.7:=
"

src_unpack() {
	cros-workon_src_unpack
	S=$S/$CROS_WORKON_SUBTREE
	cros-rust_src_unpack
}

src_compile() {
	unset CFLAGS
	ecargo_build
	use test && ecargo_test --no-run
}

src_install() {
	dobin "$(cros-rust_get_build_dir)/flashrom_tester"
}
