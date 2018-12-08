# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

CROS_WORKON_COMMIT="60b026b4ce02881b1c039adf558fda0d7846c074"
CROS_WORKON_TREE="fb3ad3c6de50a3f20671891950de5849ccacec33"
CROS_WORKON_LOCALNAME="../platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_SUBTREE="vm_tools/9s"

inherit cros-workon cros-rust

DESCRIPTION="Server binary for the 9P file system protocol"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/vm_tools/9s/"

LICENSE="BSD-Google"
SLOT="${PV}/${PR}"
KEYWORDS="*"
IUSE="test"

DEPEND="
	dev-rust/getopts:=
	dev-rust/libc:=
	dev-rust/log:=
	dev-rust/p9:=
"

src_unpack() {
	cros-workon_src_unpack
	S+="/vm_tools/9s"

	cros-rust_src_unpack
}

src_compile() {
	ecargo_build

	use test && ecargo_test --no-run
}

src_test() {
	if use x86 || use amd64; then
		ecargo_test
	else
		elog "Skipping rust unit tests on non-x86 platform"
	fi
}

src_install() {
	dobin "${CARGO_TARGET_DIR}/${CHOST}/$(usex cros-debug debug release)/9s"

	insinto /usr/share/policy
	newins "seccomp/9s-seccomp-${ARCH}.policy" 9s-seccomp.policy
}
