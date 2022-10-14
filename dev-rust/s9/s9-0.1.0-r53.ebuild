# Copyright 2018 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="99e54b29dc9c4e6e56a90b17ac1a47e1ef1052ac"
CROS_WORKON_TREE="c530c05d713e21640b126eeaec3601ebf442d0e6"
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
	dev-rust/p9:=
"

src_install() {
	newbin "$(cros-rust_get_build_dir)/p9s" 9s

	insinto /usr/share/policy
	newins "seccomp/9s-seccomp-${ARCH}.policy" 9s-seccomp.policy
}
