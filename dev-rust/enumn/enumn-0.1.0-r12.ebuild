# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="3c6367b98c28cf367ac301573d2e9d245d1ac7af"
CROS_WORKON_TREE="c5170d4e4312bcef4a4e4e49403be6bc421c18aa"
CROS_WORKON_LOCALNAME="../platform/crosvm"
CROS_WORKON_PROJECT="chromiumos/platform/crosvm"
# We don't use CROS_WORKON_OUTOFTREE_BUILD here since project's Cargo.toml is
# using "provided by ebuild" macro which supported by cros-rust.
CROS_WORKON_SUBTREE="enumn"

inherit cros-workon cros-rust

DESCRIPTION="Convert number to enum"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/+/HEAD/crosvm/enumn"

LICENSE="BSD-Google"
KEYWORDS="*"

DEPEND="
	=dev-rust/proc-macro2-1*:=
	=dev-rust/quote-1*:=
	=dev-rust/syn-1*:=
"
# (crbug.com/1182669): build-time only deps need to be in RDEPEND so they are pulled in when
# installing binpkgs since the full source tree is required to use the crate.
RDEPEND="${DEPEND}
	!!<=dev-rust/enumn-0.0.1-r4
"
