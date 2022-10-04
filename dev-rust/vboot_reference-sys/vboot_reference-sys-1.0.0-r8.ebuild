# Copyright 2022 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="6a33a0fca3e4f5cd9c3b3fd4ac0b5b8c7ffc018e"
CROS_WORKON_TREE=("09fafe5da1e38001e30f0a58acd67ab1db16a299" "e829420c9fa9f62f2a83f57313a80d8149c52a0c")
inherit cros-constants

CROS_RUST_SUBDIR="rust/vboot_reference-sys"

CROS_WORKON_PROJECT="chromiumos/platform/vboot_reference"
CROS_WORKON_LOCALNAME="../platform/vboot_reference"
CROS_WORKON_SUBTREE="host/include rust/vboot_reference-sys"

inherit cros-workon cros-rust

DESCRIPTION="Chrome OS verified boot tools Rust bindings"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/vboot_reference/+/HEAD/rust"

LICENSE="BSD-Google"
KEYWORDS="*"

# ebuilds that install executables and depend on vboot_reference-sys need to
# RDEPEND on chromeos-base/vboot_reference
DEPEND="
	dev-rust/third-party-crates-src:=
	chromeos-base/vboot_reference:=
	>=dev-rust/pkg-config-0.3.0 <dev-rust/pkg-config-0.4.0
	=dev-rust/which-4*
	>=virtual/bindgen-0.59:=
"
# (crbug.com/1182669): build-time only deps need to be in RDEPEND so they are pulled in when
# installing binpkgs since the full source tree is required to use the crate.
RDEPEND="${DEPEND}"
