# Copyright 2019 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="e5dd3b000b664fc90e51413e3827e89800081376"
CROS_WORKON_TREE=("976f46fc7a35fe6debddb4debfe252a0dbc99e0e" "a0d8550678a1ed2a4ab62782049032a024bf40df" "8c95c80bb899bf945c921df56a92e7d0cbd30582" "21b5ff9b264359a7cddb0906219da24b04491862" "956c30347917fccc691a79addf055f199b675da1" "4637d923ea08047d1285e67e6fee7776e9f4a9a3" "c4f12cb9971d84f274d7d2b14b76646b8dea8682" "3a7df68f70c7d697449fd6a965342139eb4dce18" "52b7c74c92d9fea72518839486c5ef1a3de96d62")
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
