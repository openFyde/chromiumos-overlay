# Copyright 2022 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="d8d69d02739d722bfc325c641cc98d776da29fa0"
CROS_WORKON_TREE="42d8671de090643d3928322ca21e560f623eea6d"
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
	dev-rust/third-party-crates-src:=
	dev-rust/chromeos-dbus-bindings:=
	sys-apps/dbus:=
"
# (crbug.com/1182669): build-time only deps need to be in RDEPEND so they are pulled in when
# installing binpkgs since the full source tree is required to use the crate.
RDEPEND="${DEPEND}"
