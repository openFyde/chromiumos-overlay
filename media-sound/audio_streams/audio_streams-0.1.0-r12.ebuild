# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_WORKON_COMMIT="cf6f070bc03aeb095444dff399cb53c67e6c1168"
CROS_WORKON_TREE="5712210942bec80f00c8c8a020fe8775e5b4c044"
CROS_WORKON_LOCALNAME="adhd"
CROS_WORKON_PROJECT="chromiumos/third_party/adhd"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_SUBTREE="audio_streams"

inherit cros-workon cros-rust

DESCRIPTION="Crate provides a basic interface for playing audio."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/third_party/adhd/+/master/audio_streams"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="test"

RDEPEND="!<=media-sound/audio_streams-0.1.0-r7"

src_unpack() {
	cros-workon_src_unpack
	S+="/audio_streams"

	cros-rust_src_unpack
}

src_compile() {
	use test && ecargo_test --no-run
}

src_test() {
	if use x86 || use amd64; then
		ecargo_test
	else
		elog "Skipping rust unit tests on non-x86 platform"
	fi
}

src_install() {
	cros-rust_publish "${PN}" "$(cros-rust_get_crate_version)"
}
