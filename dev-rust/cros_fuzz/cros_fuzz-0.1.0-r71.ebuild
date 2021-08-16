# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="b3ccebbf3d88a5fa1ae40e94dcb824730941c89b"
CROS_WORKON_TREE="aab23eabe3195265b0a1c06bd74eeab4e1da6fef"
CROS_RUST_SUBDIR="common/cros-fuzz"

CROS_WORKON_LOCALNAME="../platform/crosvm"
CROS_WORKON_PROJECT="chromiumos/platform/crosvm"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_SUBTREE=""  # TODO(b/195126527): limit subtree to common/

inherit cros-workon cros-rust

DESCRIPTION="Support crate for running rust fuzzers on Chrome OS"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/cros-fuzz"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="fuzzer test"

DEPEND="
	=dev-rust/rand_core-0.4*:=
"
# (crbug.com/1182669): build-time only deps need to be in RDEPEND so they are pulled in when
# installing binpkgs since the full source tree is required to use the crate.
RDEPEND="${DEPEND}"
