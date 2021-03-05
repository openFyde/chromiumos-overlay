# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="52f7d224416acd115a8d76bf0258d19bd5b0a1cd"
CROS_WORKON_TREE=("90bf2838f56bffe127636b5ea4988485595819a8" "eaed4f3b0a8201ef3951bf1960728885ff99e772")
CROS_RUST_SUBDIR="cros-fuzz"

CROS_WORKON_LOCALNAME="../platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_SUBTREE="${CROS_RUST_SUBDIR} common-mk"

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
