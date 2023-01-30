# Copyright 2022 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"
CROS_WORKON_COMMIT="0b67d44bb381764cb6ada77a61e03ea4c2369b19"
CROS_WORKON_TREE="4edebef3ad32260d34d8efa19afef03eb74562e7"
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="../platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_SUBTREE="featured"
CROS_RUST_SUBDIR="featured/rust-client"

inherit cros-workon cros-rust

DESCRIPTION="Chrome OS feature management service"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/featured/"
LICENSE="BSD-Google"
KEYWORDS="*"

DEPEND="
	dev-rust/third-party-crates-src:=
	chromeos-base/featured
"

# (crbug.com/1182669): build-time only deps need to be in RDEPEND so they are pulled in when
# installing binpkgs since the full source tree is required to use the crate.
RDEPEND="${DEPEND}"
