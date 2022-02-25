# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="cf53f13302cb3eef9236b4cabfa4b8bb39a810c6"
CROS_WORKON_TREE="2aab1d2904dfb619f622fef4012c1c1a2929ab28"
CROS_RUST_SUBDIR="chromeos-dbus-bindings"

CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="../platform2"
CROS_WORKON_SUBTREE="${CROS_RUST_SUBDIR}"

inherit cros-workon cros-rust

DESCRIPTION="Chrome OS D-Bus bindings generator for Rust."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/chromeos-dbus-bindings/"

LICENSE="BSD-Google"
SLOT="0/${PVR}"
KEYWORDS="*"

DEPEND="=dev-rust/which-4*:="
RDEPEND="!chromeos-base/chromeos-dbus-bindings-rust
	${DEPEND}"

BDEPEND=">=dev-rust/dbus-codegen-0.10.0"
