# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="81c3bc35ca6688fc07cc13583624a1cb17e9c520"
CROS_WORKON_TREE=("24afd67d10684ece0d24ee145c5c7fb6772e4f74" "a0d8550678a1ed2a4ab62782049032a024bf40df" "d6a9dd2d0564527a61f60bcb5cf91d1a1b995795" "98dba68cd28c82190ee09efa097e811530139082")
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
