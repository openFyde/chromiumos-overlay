# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="fc115e94ef327b7248ee1f1901ed3d045079bb73"
CROS_WORKON_TREE=("1cf4089d65eec19ec9c39a6fe64bda9202226412" "a0d8550678a1ed2a4ab62782049032a024bf40df" "b00310c222484b624ff9ec2378e041d7cd8f09fb" "28de0d8f31b7c079629b40b81e98707f45158909" "ac372937b4795711f04d5af57461105605663f83" "3b632cb1cbc6da698a355e078bfc220f0461deee")
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
