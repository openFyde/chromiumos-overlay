# Copyright 2022 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="151ce503d37ecda6ccb53749164fa6385a345dd2"
CROS_WORKON_TREE="57b2b1ee0a852fc7f947f72b5f9b502e77d13bb3"
CROS_WORKON_LOCALNAME="../aosp/system/update_engine"
CROS_WORKON_PROJECT="aosp/platform/system/update_engine"
CROS_WORKON_EGIT_BRANCH="master"

inherit cros-workon cros-rust

CROS_RUST_SUBDIR=""

DESCRIPTION="Rust D-Bus bindings for update_engine."
HOMEPAGE="https://chromium.googlesource.com/aosp/platform/system/update_engine/+/master/"

LICENSE="BSD-Google"
SLOT="0/${PVR}"
KEYWORDS="*"

DEPEND="
	=dev-rust/dbus-0.9*
	dev-rust/chromeos-dbus-bindings:=
"
# (crbug.com/1182669): build-time only deps need to be in RDEPEND so they are pulled in when
# installing binpkgs since the full source tree is required to use the crate.
RDEPEND="${DEPEND}"
