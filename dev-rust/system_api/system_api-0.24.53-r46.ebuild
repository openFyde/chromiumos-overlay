# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="b5d4afa8d07ec22724999f07187b03a62bd16bce"
CROS_WORKON_TREE=("4ac6ec1266588960b7883af210c5377771e73134" "a0d8550678a1ed2a4ab62782049032a024bf40df" "c9a1624f1ef2298efa532f615622efc28b4c4113" "98dba68cd28c82190ee09efa097e811530139082")
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
