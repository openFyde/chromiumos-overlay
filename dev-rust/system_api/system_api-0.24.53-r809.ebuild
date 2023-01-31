# Copyright 2019 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="9df3b6a85dc7ccddf1d1b71aa5e26dc8a35cc62f"
CROS_WORKON_TREE=("acbc53efd65b8b500dc3bbc92fb27b1d642eaddf" "a0d8550678a1ed2a4ab62782049032a024bf40df" "e83964967b249618bd8f5bbb9bf4a98de62baf15" "0dd332287e6f963a412f4b50c4b5b70167e38f40" "956c30347917fccc691a79addf055f199b675da1" "4637d923ea08047d1285e67e6fee7776e9f4a9a3" "6aa7e316443c8ac39e60d7180ae9043bbec54217" "fb8c2f02b9aa6e0c828689cbd427f6f643002d42" "3b16bf920ed3982b7882828b43096ecbe4a0c7bf")
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

BDEPEND="dev-libs/protobuf"
DEPEND="
	cros_host? ( dev-libs/protobuf:= )
	dev-rust/third-party-crates-src:=
	dev-rust/chromeos-dbus-bindings:=
	sys-apps/dbus:=
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
