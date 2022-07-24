# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# This is used to break a circular dependency caused by tests.
CROS_WORKON_COMMIT="dfd81ad0b536a7a262dd724d71d2ba3435ed6509"
CROS_WORKON_TREE="6cfc12a6cca1f0d1ddeabc20c89c96fc7bfdf49f"
CROS_RUST_REMOVE_DEV_DEPS=1
CROS_RUST_SUBDIR="sirenia/libsirenia/sirenia-rpc-macros"

CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_SUBTREE="${CROS_RUST_SUBDIR}"

inherit cros-workon cros-rust

DESCRIPTION="Macros for generating the RPC implementation for Sirenia."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/sirenia/libsirenia/sirenia-rpc-macros"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE=""

DEPEND="
	=dev-rust/anyhow-1*:=
	>=dev-rust/assert_matches-1.5.0 <dev-rust/assert_matches-2.0.0_alpha:=
	=dev-rust/proc-macro2-1*:=
	=dev-rust/quote-1*:=
	=dev-rust/syn-1*:=
"
# (crbug.com/1182669): build-time only deps need to be in RDEPEND so they are pulled in when
# installing binpkgs since the full source tree is required to use the crate.
RDEPEND="${DEPEND}"

# cros-rust_src_compile isn't used because it builds the unit tests.
src_compile() {
	ecargo_build
}

# The tests are run in libsirenia since they depend on libsirenia which depends
# on this ebuild.
src_test() { :; }
