# Copyright 2022 The ChromiumOS Authors
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.


EAPI="7"

CROS_WORKON_COMMIT="126b485ae60da47b2e9367e4e16d5f6c3677bde9"
CROS_WORKON_TREE="9ce033eb723968d27a0847f0c772b0e3fb4bc0b1"
CROS_RUST_SUBDIR="cras/src/audio_processor"

CROS_WORKON_LOCALNAME="adhd"
CROS_WORKON_PROJECT="chromiumos/third_party/adhd"
# We don't use CROS_WORKON_OUTOFTREE_BUILD here since cras/src/audio_processor is
# using the `provided by ebuild` macro from the cros-rust eclass
CROS_WORKON_SUBTREE="${CROS_RUST_SUBDIR}"

inherit cros-workon cros-rust

DESCRIPTION="Audio processor"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/third_party/adhd/+/HEAD/cras/src/audio_processor"

LICENSE="BSD-Google"
KEYWORDS="*"

DEPEND="
	dev-rust/third-party-crates-src:=
	>=dev-rust/clap-3.1.12 <dev-rust/clap-4.0
	=dev-rust/bindgen-0.59*
"
RDEPEND="${DEPEND}"
