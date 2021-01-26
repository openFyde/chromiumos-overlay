# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="37084473ad1cccd4b0f6b6e7ecad65a6d2e852a9"
CROS_WORKON_TREE=("2336cfdf1864aa183d4f099c233c999636f9d5e1" "233c1e857eea6027e18c75e2ab20af1094addfc6")
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
