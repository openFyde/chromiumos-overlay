# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

# This lives separately from the main minijail ebuild since we don't have Rust
# available in the SDK builder.
# TODO: Consider moving back into main ebuild once crbug.com/1046088 is
# resolved.

EAPI=7

inherit cros-constants

CROS_WORKON_MANUAL_UPREV=1
CROS_WORKON_LOCALNAME="../aosp/external/minijail"
CROS_WORKON_PROJECT="platform/external/minijail"
CROS_WORKON_EGIT_BRANCH="master"
CROS_WORKON_REPO="${CROS_GIT_AOSP_URL}"
CROS_WORKON_SUBTREE="rust/minijail-sys"

inherit cros-workon cros-rust

DESCRIPTION="rust bindings for minijail"
HOMEPAGE="https://android.googlesource.com/platform/external/minijail"

LICENSE="BSD-Google"
KEYWORDS="~*"
IUSE="test"

# ebuilds that install executables and depend on minijail-sys need to RDEPEND on
# chromeos-base/minijail and sys-libs/libcap
DEPEND="
	chromeos-base/minijail:=
	>=dev-rust/libc-0.2.44:= <dev-rust/libc-0.3.0
	>=dev-rust/pkg-config-0.3.0:= <dev-rust/pkg-config-0.4.0
	sys-libs/libcap:=
	virtual/bindgen:=
"
# (crbug.com/1182669): build-time only deps need to be in RDEPEND so they are pulled in when
# installing binpkgs since the full source tree is required to use the crate.
RDEPEND="${DEPEND}"

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
