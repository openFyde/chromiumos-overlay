# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="3939f80302655994bb2235405c7887797a58db8a"
CROS_WORKON_TREE=("b784c5e32fd3bd0b6a7885b50fbc2018aff72e72" "a0d8550678a1ed2a4ab62782049032a024bf40df" "b4f216525f44716ad01f39b0d8fe4a59e448992b" "38596a526a5a249a570f36e96d789a5a9022b323" "e54be0f555fddae41c01fbbcabed7ed7973d78f3" "43cdd2cb3bf36a0e8e64536e33ce29245b433c51")
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
