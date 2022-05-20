# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="3d6e9979c705f934cafdf3030769695bbf41c2ed"
CROS_WORKON_TREE=("5b775934fbbe65c9597174273b2ee0c1c1795d20" "a0d8550678a1ed2a4ab62782049032a024bf40df" "f2eb2baa58d53161a48e2339b7ac82c52a32fe1d" "af405cba36b3d4453fdf636dbd155958063465fb" "e54be0f555fddae41c01fbbcabed7ed7973d78f3" "41983f98e3979f6b0bf7d011af1798d85a63f9ff" "ddd22f0572ba73430977571c1084513fb9c7fcc3")
CROS_RUST_SUBDIR="system_api"

CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="../platform2"
CROS_WORKON_SUBTREE="${CROS_RUST_SUBDIR} authpolicy/dbus_bindings cryptohome/dbus_bindings debugd/dbus_bindings login_manager/dbus_bindings shill/dbus_bindings power_manager/dbus_bindings"

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

src_install() {
	# We don't want the build.rs to get packaged with the crate. Otherwise
	# we will try and regenerate the bindings.
	rm build.rs || die "Cannot remove build.rs"

	cros-rust_src_install
}
