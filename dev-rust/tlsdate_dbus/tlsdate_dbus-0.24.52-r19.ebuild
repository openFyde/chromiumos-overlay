# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="455e94de717eb1de419e0730b60bd9f9655d6183"
CROS_WORKON_TREE="eb4bd7c16e83556e5a12b73361044ded0f2d7116"
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
