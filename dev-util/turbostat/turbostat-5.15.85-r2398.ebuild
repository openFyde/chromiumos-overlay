# Copyright 2013 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="27ccc3f666ae58e28ebd2a1e6d2d0cb682ef63d1"
CROS_WORKON_TREE=("86a6c94c68a65c44d9747ef217161b474c3d02d5" "6b78b1ed40e46da32ab53c3fd5fd0563a6edb02e" "5109bcac5a290f58a3c74b3659ff0d138bca5280")
CROS_WORKON_PROJECT="chromiumos/third_party/kernel"
CROS_WORKON_LOCALNAME="kernel/v5.15"
CROS_WORKON_EGIT_BRANCH="chromeos-5.15"
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
