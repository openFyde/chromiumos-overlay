# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

# This lives separately from the main minijail ebuild since we don't have Rust
# available in the SDK builder.
# TODO: Consider moving back into main ebuild once crbug.com/1046088 is
# resolved.

EAPI=7

inherit cros-constants

CROS_WORKON_COMMIT="69e3fc6e858dfcac83c0d8ed43bcf62dae871319"
CROS_WORKON_TREE="610c6ce909f9e1d024fafeee42d7d008fc6f22d2"
CROS_WORKON_BLACKLIST=1
CROS_WORKON_LOCALNAME="../aosp/external/minijail"
CROS_WORKON_PROJECT="platform/external/minijail"
CROS_WORKON_REPO="${CROS_GIT_AOSP_URL}"
CROS_WORKON_SUBTREE="rust/minijail"

inherit cros-workon cros-rust

DESCRIPTION="rust bindings for minijail"
HOMEPAGE="https://android.googlesource.com/platform/external/minijail"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="asan test"

DEPEND="
	>=dev-rust/libc-0.2.44:= <dev-rust/libc-0.3.0
	dev-rust/minijail-sys:=
"

src_unpack() {
	# Unpack both the minijail and Rust dependency source code.
	cros-workon_src_unpack
	S+="/rust/minijail"

	cros-rust_src_unpack
}

src_compile() {
	if use x86 || use amd64; then
		use test && ecargo_test --no-run
	fi
}

src_test() {
	if cros-rust_use_sanitizers; then
		# crbug.com/1097761 The unit tests for this package leak threads.
		elog "Skipping rust unit tests for ASAN because fork leaks threads."
	elif use x86 || use amd64; then
		ecargo_test
	else
		elog "Skipping rust unit tests on non-x86 platform"
	fi
}
