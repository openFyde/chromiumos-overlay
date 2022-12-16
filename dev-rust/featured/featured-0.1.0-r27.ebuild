# Copyright 2022 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"
CROS_WORKON_COMMIT="f23d7a09a082a3f22281790afd9beaae04b23f65"
CROS_WORKON_TREE="5f005754494e51c6143bb3c8d33f043878ff3f80"
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
