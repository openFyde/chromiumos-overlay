# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

# This lives separately from the main minijail ebuild since we don't have Rust
# available in the SDK builder.
# TODO: Consider moving back into main ebuild once crbug.com/1046088 is
# resolved.

EAPI=7

inherit cros-constants

CROS_WORKON_COMMIT="96dd14e0abd27f2aaac1dc5b8ff40f17e79605f0"
CROS_WORKON_TREE="c12462bccb06babed5abc2a8e153f3ff5b04d259"
CROS_WORKON_BLACKLIST=1
CROS_WORKON_LOCALNAME="../aosp/external/minijail"
CROS_WORKON_PROJECT="platform/external/minijail"
CROS_WORKON_REPO="${CROS_GIT_AOSP_URL}"
CROS_WORKON_SUBTREE="rust/minijail-sys"

inherit cros-workon cros-rust

DESCRIPTION="rust bindings for minijail"
HOMEPAGE="https://android.googlesource.com/platform/external/minijail"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="test"

COMMON_DEPEND="
	chromeos-base/minijail:=
	sys-libs/libcap:=
   "

RDEPEND="${COMMON_DEPEND}"
DEPEND="
	${COMMON_DEPEND}
	>=dev-rust/libc-0.2.44:= <dev-rust/libc-0.3.0
	>=dev-rust/pkg-config-0.3.0:= <dev-rust/pkg-config-0.4.0
"

src_unpack() {
	# Unpack both the minijail and Rust dependency source code.
	cros-workon_src_unpack
	S+="/rust/minijail-sys"

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
