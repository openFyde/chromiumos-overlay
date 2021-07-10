# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="3f590fea35060c89bb24c93ba4f0edc29313b55b"
CROS_WORKON_TREE=("6df26e85b4050e8c21b2e8098586c7d18a06e7f6" "a0d8550678a1ed2a4ab62782049032a024bf40df" "c3e1fc5061dcbd62acb501f21d7a3794f41b2160" "343b50fe472eefae651d8c7df11baed4b839a357" "3b632cb1cbc6da698a355e078bfc220f0461deee")
CROS_RUST_SUBDIR="system_api"

CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="../platform2"
CROS_WORKON_SUBTREE="${CROS_RUST_SUBDIR} authpolicy/dbus_bindings debugd/dbus_bindings login_manager/dbus_bindings shill/dbus_bindings"

inherit cros-workon cros-rust

DESCRIPTION="Chrome OS system API D-Bus bindings for Rust."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/system_api/"

LICENSE="BSD-Google"
SLOT="0/${PVR}"
KEYWORDS="*"

DEPEND="
	dev-rust/chromeos-dbus-bindings:=
	=dev-rust/dbus-0.8*:=
"
# (crbug.com/1182669): build-time only deps need to be in RDEPEND so they are pulled in when
# installing binpkgs since the full source tree is required to use the crate.
RDEPEND="${DEPEND}
	!chromeos-base/system_api-rust
"
