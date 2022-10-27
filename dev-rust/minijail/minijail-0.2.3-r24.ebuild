# Copyright 2020 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

# This lives separately from the main minijail ebuild since we don't have Rust
# available in the SDK builder.
# TODO: Consider moving back into main ebuild once crbug.com/1046088 is
# resolved.

EAPI=7

CROS_WORKON_COMMIT="90e7912ac45bc84a7f7f773bfaa26b5ad695cb91"
CROS_WORKON_TREE="23c3843247166e736eca4cdee58cf9f29e2fd544"
inherit cros-constants

CROS_RUST_SUBDIR="rust/minijail"

CROS_WORKON_LOCALNAME="../platform/minijail"
CROS_WORKON_PROJECT="chromiumos/platform/minijail"
CROS_WORKON_EGIT_BRANCH="main"
CROS_WORKON_SUBTREE="${CROS_RUST_SUBDIR}"

inherit cros-workon cros-rust

DESCRIPTION="rust bindings for minijail"
HOMEPAGE="https://google.github.io/minijail"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="asan test"

DEPEND="
	dev-rust/third-party-crates-src:=
	>=dev-rust/minijail-sys-0.0.13:=
"
# (crbug.com/1182669): build-time only deps need to be in RDEPEND so they are pulled in when
# installing binpkgs since the full source tree is required to use the crate.
RDEPEND="${DEPEND}"

src_test() {
	local args=( -- --test-threads=1 )
	if ! use amd64; then
		# TODO(crbug.com/1201377) enable all tests on ARM when supported.
		args=( --lib "${args[@]}" --skip 'seccomp_no_new_privs' )
	fi
	cros-rust_src_test "${args[@]}"
}
