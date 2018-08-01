# Copyright (c) 2013 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5
CROS_WORKON_COMMIT="5d1d06efd9bef76db60417c9abdd62d0bd5567ad"
CROS_WORKON_TREE="a043ce1b362ee260cbe7cb5b2858d7fa664fd3fc"
CROS_WORKON_PROJECT="chromiumos/third_party/kernel"
CROS_WORKON_LOCALNAME="kernel/v4.14"
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_OUTOFTREE_BUILD=1

inherit cros-workon toolchain-funcs

HOMEPAGE="https://www.kernel.org/"
DESCRIPTION="Intel processor C-state and P-state reporting tool"

LICENSE="GPL-2"
SLOT=0
KEYWORDS="*"
IUSE="-asan"

domake() {
	emake -C tools/power/x86/turbostat \
		BUILD_OUTPUT="$(cros-workon_get_build_dir)" DESTDIR="${D}" \
		CC="$(tc-getCC)" "$@"
}

src_configure() {
	asan-setup-env
	cros-workon_src_configure
}

src_compile() {
	domake
}

src_install() {
	domake install
}
