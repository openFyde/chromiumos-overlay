# Copyright 2019 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="5c9a6fba0d74632f035e9b09cf771773c8b32335"
CROS_WORKON_TREE=("62f854b7c5581783553da7443ed0d5bc64dca23f" "a0d8550678a1ed2a4ab62782049032a024bf40df" "50fdf25a7646d4d3f6dfbfa46fd58b710714e241" "b3ee4795f9991549b97eef380b4f105904dc4a89" "956c30347917fccc691a79addf055f199b675da1" "402fa94a6c06832dec791de83b5880d832043b6e" "da9f312a20afddbca511eadcd2e20a6bffd32e75" "c52312b3a3c0c253709a4bc86ecdfc2ff97120e0" "738283c4a8ccaca24fd7b8aedd6461947cc699ba")
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
	=dev-rust/dbus-0.9*
	>=dev-rust/protobuf-2.16.2 <dev-rust/protobuf-3
	>=dev-rust/protoc-rust-2.16.2 <dev-rust/protoc-rust-3
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
