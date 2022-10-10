# Copyright 2019 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="dac22b0fff1d5e7f74ebd1d8e8735e99434198b4"
CROS_WORKON_TREE="8298deca1fc76bb8a7b0e427ef3daba23cc3e7b8"
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
	=dev-rust/arbitrary-1*
	=dev-rust/once_cell-1*
	=dev-rust/rand_core-0.4*
	=dev-rust/rand_core-0.6*
"
# (crbug.com/1182669): build-time only deps need to be in RDEPEND so they are pulled in when
# installing binpkgs since the full source tree is required to use the crate.
RDEPEND="${DEPEND}"
