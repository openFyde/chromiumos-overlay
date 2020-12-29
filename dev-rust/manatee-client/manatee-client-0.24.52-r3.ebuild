# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="81c3bc35ca6688fc07cc13583624a1cb17e9c520"
CROS_WORKON_TREE=("2336cfdf1864aa183d4f099c233c999636f9d5e1" "bbcb9d3c399693aac6cde20e091eb62ee734e22b")
CROS_RUST_SUBDIR="sirenia/manatee-client"

CROS_WORKON_LOCALNAME="../platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_SUBTREE="${CROS_RUST_SUBDIR} sirenia/dbus_bindings"

inherit cros-workon cros-rust

DESCRIPTION="Rust D-Bus bindings for ManaTEE."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/sirenia/manatee-client"

LICENSE="BSD-Google"
SLOT="0/${PVR}"
KEYWORDS="*"

RDEPEND=""

DEPEND="${RDEPEND}
	=dev-rust/dbus-0.8*:=
	dev-rust/chromeos-dbus-bindings:=
"
