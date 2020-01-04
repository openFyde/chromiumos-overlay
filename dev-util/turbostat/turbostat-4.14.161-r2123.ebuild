# Copyright (c) 2013 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5
CROS_WORKON_COMMIT="bcde7a6c2c9c598b8966d095ae8009e382af9d4c"
CROS_WORKON_TREE=("c4026f60cd9e13ee9351fa5c563bd49d1bb95e8f" "cdb215ba40d57e671d3ab2105932980137c01eda" "c104b2cfaaf623162d453b0296ed29ba5a7a0823")
CROS_WORKON_PROJECT="chromiumos/third_party/kernel"
CROS_WORKON_LOCALNAME="kernel/v4.14"
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_OUTOFTREE_BUILD=1
# Narrow the workon scope to just files referenced by the turbostat
# Makefile:
# https://chromium.googlesource.com/chromiumos/third_party/kernel/+/chromeos-4.14/tools/power/x86/turbostat/Makefile#12
CROS_WORKON_SUBTREE="arch/x86/include/asm tools/include tools/power/x86/turbostat"

inherit cros-sanitizers cros-workon toolchain-funcs

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
	sanitizers-setup-env
	cros-workon_src_configure
}

src_compile() {
	domake
}

src_install() {
	domake install
}
