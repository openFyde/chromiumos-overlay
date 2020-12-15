# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="178d940c8fa20666117208b3a6e40ed28579f122"
CROS_WORKON_TREE=("b179ef2d6bcfd24f34afc41cf360ab4cd18bd81b" "a0d8550678a1ed2a4ab62782049032a024bf40df" "43706fa6f0a04a2c0841079bd83fd0b07c82a9ab" "d289fda3c8ee1448b8cdf3425062327cde39dd8c")
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
