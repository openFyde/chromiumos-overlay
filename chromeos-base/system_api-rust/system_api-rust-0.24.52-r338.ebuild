# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="3ad7c5424eb72456ac7dff67b10a1afa414cba42"
CROS_WORKON_TREE=("24792ec1d3644f37e681897ff6cb1d758bf2da63" "a0d8550678a1ed2a4ab62782049032a024bf40df" "be80c2e6e90c8c30e37139c11ed431f4db093b57" "98dba68cd28c82190ee09efa097e811530139082")
CROS_RUST_SUBDIR="system_api"

CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_SUBTREE="${CROS_RUST_SUBDIR} authpolicy/dbus_bindings debugd/dbus_bindings login_manager/dbus_bindings"

inherit cros-workon cros-rust

CROS_RUST_CRATE_NAME="system_api"
DESCRIPTION="Chrome OS system API D-Bus bindings for Rust."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/system_api/"

LICENSE="BSD-Google"
SLOT="0/${PVR}"
KEYWORDS="*"

RDEPEND=""

DEPEND="${RDEPEND}
	>chromeos-base/chromeos-dbus-bindings-rust-0.24.52-r16:=
	=dev-rust/dbus-0.8*:=
"
