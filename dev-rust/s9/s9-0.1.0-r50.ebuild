# Copyright 2018 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="084847222f2a38ca3b9efcf8ca9dfc0e97119e75"
CROS_WORKON_TREE="7de3033e5416f76ef94ef6b32921a83d0f1112c8"
CROS_RUST_SUBDIR="vm_tools/9s"

CROS_WORKON_LOCALNAME="../platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_SUBTREE="${CROS_RUST_SUBDIR}"

CROS_RUST_CRATE_NAME="p9s"

inherit cros-workon cros-rust

DESCRIPTION="Server binary for the 9P file system protocol"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/vm_tools/9s/"

LICENSE="BSD-Google"
SLOT="0/0"
KEYWORDS="*"
IUSE="test"

RDEPEND="
	!<chromeos-base/crosvm-0.0.1-r260
	!dev-rust/9s
"
DEPEND="
	dev-rust/third-party-crates-src:=
	=dev-rust/getopts-0.2*
	dev-rust/libchromeos:=
	=dev-rust/log-0.4*
	dev-rust/p9:=
	dev-rust/sys_util:=
"

src_install() {
	newbin "$(cros-rust_get_build_dir)/p9s" 9s

	insinto /usr/share/policy
	newins "seccomp/9s-seccomp-${ARCH}.policy" 9s-seccomp.policy
}
