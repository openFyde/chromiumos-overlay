# Copyright 2022 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"
CROS_WORKON_COMMIT="7d409268f1f6b6f95384c287023481bfbd5888dc"
CROS_WORKON_TREE="ff5a27942a7a9be870ca44c0c2c3e2bf709e1d67"
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
