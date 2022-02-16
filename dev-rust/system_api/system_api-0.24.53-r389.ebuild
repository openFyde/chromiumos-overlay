# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="f7f35edad2876744147deefafe519095768cac33"
CROS_WORKON_TREE=("49881307c4f23c9fa3d00a30f1b1e0f05b8a459d" "a0d8550678a1ed2a4ab62782049032a024bf40df" "ce5574dce15ac01944baf617d8b52ead9dca5c98" "e1b5a03bdb350d1f65e14e63f144f5a9d5fc552b" "e54be0f555fddae41c01fbbcabed7ed7973d78f3" "0fb497918a556fc7f79f1d7e5cede1d85be01409")
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
