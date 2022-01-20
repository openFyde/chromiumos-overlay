# Copyright 2022 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="283db281e27e89adabf40fbd8dabd4f489f083f4"
CROS_WORKON_TREE=("122ceb184fa0013a15fa4a0d4644fec0c6a8778c" "e829420c9fa9f62f2a83f57313a80d8149c52a0c")
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
	chromeos-base/vboot_reference:=
"
# (crbug.com/1182669): build-time only deps need to be in RDEPEND so they are pulled in when
# installing binpkgs since the full source tree is required to use the crate.
RDEPEND="${DEPEND}"
