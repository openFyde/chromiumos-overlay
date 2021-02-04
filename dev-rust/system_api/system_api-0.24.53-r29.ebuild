# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="d4a082f3c2be03da83c15fb0e389500045d730a8"
CROS_WORKON_TREE=("15c118cea4447f80ddb353d3e07eb307bb993da8" "a0d8550678a1ed2a4ab62782049032a024bf40df" "c9a1624f1ef2298efa532f615622efc28b4c4113" "98dba68cd28c82190ee09efa097e811530139082")
CROS_RUST_SUBDIR="system_api"

CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="../platform2"
CROS_WORKON_SUBTREE="${CROS_RUST_SUBDIR} authpolicy/dbus_bindings debugd/dbus_bindings login_manager/dbus_bindings"

inherit cros-workon cros-rust

DESCRIPTION="Chrome OS system API D-Bus bindings for Rust."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/system_api/"

LICENSE="BSD-Google"
SLOT="0/${PVR}"
KEYWORDS="*"

RDEPEND="!chromeos-base/system_api-rust"

DEPEND="${RDEPEND}
	dev-rust/chromeos-dbus-bindings:=
	=dev-rust/dbus-0.8*:=
"
