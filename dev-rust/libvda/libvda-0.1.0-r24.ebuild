# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="cc55fd248b036e2a2feb8a746fb07cb370563dbc"
CROS_WORKON_TREE="ef853e60ca368159e6086ff7ad9b3c9a9629af5c"
CROS_WORKON_LOCALNAME="../platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
# We don't use CROS_WORKON_OUTOFTREE_BUILD here since project's Cargo.toml is
# using "provided by ebuild" macro which supported by cros-rust.
CROS_WORKON_SUBTREE="arc/vm/libvda/rust"

CROS_RUST_SUBDIR="arc/vm/libvda/rust"

inherit cros-workon cros-rust

DESCRIPTION="Rust wrapper for chromeos-base/libvda"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/arc/vm/libvda/rust"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="test"

RDEPEND="
	chromeos-base/libvda:=
	!!<=dev-rust/libvda-0.0.1-r5
"

DEPEND="
	${RDEPEND}
	dev-rust/pkg-config:=
	dev-rust/enumn:=
"

src_test() {
	local test_args
	if ! use amd64; then
		# (b/174605753) Skip x86_64 specific tests.
		test_args=(
			"--"
			"--skip" "bindgen_test_layout_vda_capabilities"
			"--skip" "bindgen_test_layout_vda_session_info"
			"--skip" "bindgen_test_layout_vea_capabilities"
			"--skip" "bindgen_test_layout_vea_session_info"
		)
	fi
	cros-rust_src_test "${test_args[@]}"
}
