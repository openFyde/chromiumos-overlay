# Copyright 2019 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="5e0b5089a827145720fbcdce9198a786db3d6ff4"
CROS_WORKON_TREE="70c31d511e6a1f7f82addf71379eb368f9d18148"
CROS_RUST_SUBDIR="common/cros-fuzz"

CROS_WORKON_LOCALNAME="../platform/crosvm"
CROS_WORKON_PROJECT="chromiumos/platform/crosvm"
CROS_WORKON_EGIT_BRANCH="chromeos"
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_SUBTREE=""  # TODO(b/195126527): limit subtree to common/
CROS_WORKON_EGIT_BRANCH="chromeos"

inherit cros-workon cros-rust

DESCRIPTION="Support crate for running rust fuzzers on Chrome OS"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/cros-fuzz"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="fuzzer test"

DEPEND="
	dev-rust/third-party-crates-src:=
	=dev-rust/once_cell-1*
"
# (crbug.com/1182669): build-time only deps need to be in RDEPEND so they are pulled in when
# installing binpkgs since the full source tree is required to use the crate.
RDEPEND="${DEPEND}"
