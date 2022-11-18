# Copyright 2019 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="219ce1140396073c03f801ce75bc45d731d9c9dc"
CROS_WORKON_TREE=("4975734bae10e681a962509eb15eb768e31b93ed" "a0d8550678a1ed2a4ab62782049032a024bf40df" "50fdf25a7646d4d3f6dfbfa46fd58b710714e241" "3b79fb687b945eebe8e59da80fb173096ec02063" "956c30347917fccc691a79addf055f199b675da1" "5553e9df87365e5c6350d7ba59a80527ecc53f13" "da9f312a20afddbca511eadcd2e20a6bffd32e75" "4a48e16107089178a899c108ac20ebe4fba32b75" "b760835cd40f267aace75dec9a0704de70356bd5")
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
