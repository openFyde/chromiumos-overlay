# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="5fb1b3b57380ef8a9782bb316d6363f9a4e6c29e"
CROS_WORKON_TREE="1fdc252988ebd34ddfc3d31459bf5ea16ef33fa6"
CROS_WORKON_PROJECT="chromiumos/third_party/tlsdate"
CROS_WORKON_EGIT_BRANCH="master"
CROS_WORKON_LOCALNAME="tlsdate"

inherit cros-workon cros-rust

CROS_RUST_SUBDIR=""

DESCRIPTION="Rust D-Bus bindings for tlsdate."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/third_party/tlsdate/+/master/"

LICENSE="BSD-Google"
SLOT="0/${PVR}"
KEYWORDS="*"

DEPEND="
	=dev-rust/dbus-0.8*:=
	dev-rust/chromeos-dbus-bindings:=
"
# (crbug.com/1182669): build-time only deps need to be in RDEPEND so they are pulled in when
# installing binpkgs since the full source tree is required to use the crate.
RDEPEND="${DEPEND}"
