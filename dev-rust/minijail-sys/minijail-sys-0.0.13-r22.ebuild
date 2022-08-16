# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

# This lives separately from the main minijail ebuild since we don't have Rust
# available in the SDK builder.
# TODO: Consider moving back into main ebuild once crbug.com/1046088 is
# resolved.

EAPI=7

CROS_WORKON_COMMIT="485c8a098c5b1a63f079461826ed45571f2a0032"
CROS_WORKON_TREE="e6c4970f8bc11bd88c25fb8570a37c9a543f23c5"
inherit cros-constants

CROS_RUST_SUBDIR="rust/minijail-sys"

CROS_WORKON_LOCALNAME="../platform/minijail"
CROS_WORKON_PROJECT="chromiumos/platform/minijail"
CROS_WORKON_EGIT_BRANCH="main"

inherit cros-workon cros-rust

DESCRIPTION="rust bindings for minijail"
HOMEPAGE="https://google.github.io/minijail"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="test"

# ebuilds that install executables and depend on minijail-sys need to RDEPEND on
# chromeos-base/minijail and sys-libs/libcap
DEPEND="
	chromeos-base/minijail:=
	>=dev-rust/libc-0.2.44:= <dev-rust/libc-0.3.0
	>=dev-rust/pkg-config-0.3.0:= <dev-rust/pkg-config-0.4.0
	=dev-rust/which-4*:=
	sys-libs/libcap:=
	virtual/bindgen:=
"
# (crbug.com/1182669): build-time only deps need to be in RDEPEND so they are pulled in when
# installing binpkgs since the full source tree is required to use the crate.
RDEPEND="${DEPEND}"

src_prepare() {
	cros-rust_src_prepare
	# Do not skip regeneration of libminijail.rs.
	export CROS_RUST=0
}
