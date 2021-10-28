# Copyright (c) 2013 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="13103b49d58604968f7e0c755ff1286eff7c6dcd"
CROS_WORKON_TREE=("a8821cc7b45704b153b3fe1f24b5a08244bcf463" "fa703ad766fda3d500b8114d3ad3cd7aa8babab6" "82f471a1f381850d569b3edbfa0ba3ec42139f56")
CROS_WORKON_PROJECT="chromiumos/third_party/kernel"
CROS_WORKON_LOCALNAME="kernel/v5.10"
CROS_WORKON_EGIT_BRANCH="chromeos-5.10"
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
SLOT="0/0"
KEYWORDS="*"
IUSE="-asan"

RDEPEND="sys-libs/libcap:="

DEPEND="${RDEPEND}"

domake() {
	emake -C tools/power/x86/turbostat \
		BUILD_OUTPUT="$(cros-workon_get_build_dir)" DESTDIR="${D}" \
		CC="$(tc-getCC)" "$@"
}

src_configure() {
	sanitizers-setup-env
	default
}

src_compile() {
	domake
}

src_install() {
	domake install
}
