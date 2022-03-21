# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="32927f995d36793d1abae6381a07d79cb1e31752"
CROS_WORKON_TREE=("d40de0f701e66e07d84d6e9b65d08d7a3b51c6e6" "a0d8550678a1ed2a4ab62782049032a024bf40df" "ce5574dce15ac01944baf617d8b52ead9dca5c98" "51b217ebe9d2e2a749d0d8b01943858c3122191f" "e54be0f555fddae41c01fbbcabed7ed7973d78f3" "41983f98e3979f6b0bf7d011af1798d85a63f9ff")
CROS_RUST_SUBDIR="system_api"

CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="../platform2"
CROS_WORKON_SUBTREE="${CROS_RUST_SUBDIR} authpolicy/dbus_bindings cryptohome/dbus_bindings debugd/dbus_bindings login_manager/dbus_bindings shill/dbus_bindings"

inherit cros-workon cros-rust

DESCRIPTION="Chrome OS system API D-Bus bindings for Rust."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/system_api/"

LICENSE="BSD-Google"
SLOT="0/${PVR}"
KEYWORDS="*"

DEPEND="
	dev-rust/chromeos-dbus-bindings:=
	=dev-rust/dbus-0.9*:=
	>=dev-rust/protobuf-2.16.2:= <dev-rust/protobuf-3
	>=dev-rust/protoc-rust-2.16.2:= <dev-rust/protoc-rust-3
"
# (crbug.com/1182669): build-time only deps need to be in RDEPEND so they are pulled in when
# installing binpkgs since the full source tree is required to use the crate.
RDEPEND="${DEPEND}
	!chromeos-base/system_api-rust
"
