# Copyright 2019 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="373d8da764f76170412f9d6b895f69f743ce00fa"
CROS_WORKON_TREE="96c507ab1179bab8f5ec4c2778a6d8dd3b0bef57"
CROS_RUST_SUBDIR="common/cros-fuzz"

CROS_WORKON_LOCALNAME="../platform/crosvm"
CROS_WORKON_PROJECT="chromiumos/platform/crosvm"
CROS_WORKON_EGIT_BRANCH="chromeos"
CROS_WORKON_OUTOFTREE_BUILD=1
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
	=dev-rust/rand_core-0.4*
	=dev-rust/rand_core-0.6*
"
# (crbug.com/1182669): build-time only deps need to be in RDEPEND so they are pulled in when
# installing binpkgs since the full source tree is required to use the crate.
RDEPEND="${DEPEND}"
