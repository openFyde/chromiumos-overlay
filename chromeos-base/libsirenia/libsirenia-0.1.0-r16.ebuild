# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="d5bd453b7a24f4bc5b93408a793da3149406a526"
CROS_WORKON_TREE="36749988683ed09546c9aaebe9f124beceb722e1"
CROS_RUST_SUBDIR="sirenia/libsirenia"

CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_SUBTREE="${CROS_RUST_SUBDIR}"

inherit cros-workon cros-rust

DESCRIPTION="The support library for the ManaTEE runtime environment."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/sirenia/libsirenia"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE=""

RDEPEND=""

DEPEND="${RDEPEND}
	chromeos-base/sirenia-rpc-macros:=
	>=dev-rust/flexbuffers-0.1.1:= <dev-rust/flexbuffers-0.2
	=dev-rust/getopts-0.2*:=
	>=dev-rust/libc-0.2.44:= <dev-rust/libc-0.3
	dev-rust/libchromeos:=
	dev-rust/minijail:=
	>=dev-rust/serde-1.0.114:= <dev-rust/serde-2
	=dev-rust/serde_derive-1*:=
	dev-rust/sys_util:=
	>=dev-rust/thiserror-1.0.20:= <dev-rust/thiserror-2.0
"

# We skip the vsock test because it requires the vsock kernel modules to be
# loaded.
src_test() {
	cros-rust_src_test -- --skip transport::tests::vsocktransport

	# Run tests for sirenia-rpc-macros here since the tests depend on libsirenia
	# and libsirenia depends on sirenia-rpc-macros.
	(
		cd sirenia-rpc-macros || die
		cros-rust_src_test
	)
}
