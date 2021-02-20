# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="162afbd0719dbfa331005e78119062d2d56a3a8c"
CROS_WORKON_TREE=("b2dad9801935e24652ed4a83ac28e4d960d14c26" "a0d8550678a1ed2a4ab62782049032a024bf40df" "c9a1624f1ef2298efa532f615622efc28b4c4113" "98dba68cd28c82190ee09efa097e811530139082")
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
