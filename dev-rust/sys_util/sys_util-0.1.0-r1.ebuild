# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

CROS_WORKON_COMMIT="d41d726c2f977789fdd3f6cd701f0c7616b778ac"
CROS_WORKON_TREE="6aece87ce49bea5a9d15cc398e66d3415884611a"
CROS_WORKON_LOCALNAME="../platform/crosvm"
CROS_WORKON_PROJECT="chromiumos/platform/crosvm"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_SUBTREE="sys_util"

inherit cros-workon cros-rust

DESCRIPTION="Small system utility modules for usage by other modules."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/+/master/crosvm/sys_util"

LICENSE="BSD-Google"
SLOT="${PV}/${PR}"
KEYWORDS="*"
IUSE="test"

DEPEND="
	>=dev-rust/libc-0.2.44:=
	~dev-rust/quote-0.6.10:=
	>=dev-rust/proc-macro2-0.4:=
	>=dev-rust/syn-0.15:=
	dev-rust/data_model:=
	dev-rust/sync:=
	dev-rust/syscall_defines:=
"

src_unpack() {
	cros-workon_src_unpack
	S+="/sys_util"

	cros-rust_src_unpack
}

src_compile() {
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
	pushd poll_token_derive > /dev/null
	cros-rust_publish poll_token_derive "$(cros-rust_get_crate_version ${S}/poll_token_derive)"
	popd > /dev/null

	cros-rust_publish "${PN}" "$(cros-rust_get_crate_version)"
}
