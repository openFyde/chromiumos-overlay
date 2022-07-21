# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="8e0b30dbed4b2409c84c0872432f51da9caa9ffe"
CROS_WORKON_TREE=("e84d3b0b4215042bee8889125c98af63f8f8b7d5" "a0d8550678a1ed2a4ab62782049032a024bf40df" "977d49fa7e04eb0af74fa77165ab6b9e60486283" "c7bd7c1304c81d7c3da4a5a1c334537d2a9a8226" "8829a5a24648f7ac6d85554f6e0e8bb8ac9cde29" "489a8c6359833cc0dd9677de6f90d9bf5d9be037" "7cc201f289fa9c069a6d875631a08fee7c97d439" "ddd22f0572ba73430977571c1084513fb9c7fcc3" "0cba4e910a25ebe32645ab268db10a25245ec8a8")
CROS_RUST_SUBDIR="system_api"

CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="../platform2"
CROS_WORKON_SUBTREE="${CROS_RUST_SUBDIR} authpolicy/dbus_bindings cryptohome/dbus_bindings debugd/dbus_bindings dlcservice/dbus_adaptors login_manager/dbus_bindings shill/dbus_bindings power_manager/dbus_bindings vtpm"

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
