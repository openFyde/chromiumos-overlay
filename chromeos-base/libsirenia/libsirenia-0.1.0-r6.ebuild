# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="57779f9c27d62896f66cced9cc88443ae9585372"
CROS_WORKON_TREE="9632d3dbd2327ea0d7c0054e521ac80fcfbf8318"
CROS_RUST_SUBDIR="sirenia/libsirenia"

CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_SUBTREE="${CROS_RUST_SUBDIR}"

inherit cros-workon cros-rust user

DESCRIPTION="The support library for the ManaTEE runtime environment."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/sirenia/libsirenia"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="cros_host"

RDEPEND=""

DEPEND="${RDEPEND}
	>=dev-rust/flexbuffers-0.1.1:= <dev-rust/flexbuffers-0.2
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
}
