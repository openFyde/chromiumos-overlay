# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="6667fa40bf42371d9216a05a8fb53f758083b33a"
CROS_WORKON_TREE="649741cbc2f479423b5cdd772794129d163cc7e3"
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

# ebuilds that install executables and depend on dev-rust/libvda need to RDEPEND
# on chromeos-base/libvda.
DEPEND="chromeos-base/libvda:=
	dev-rust/pkg-config:=
	dev-rust/enumn:=
"
# (crbug.com/1182669): build-time only deps need to be in RDEPEND so they are pulled in when
# installing binpkgs since the full source tree is required to use the crate.
RDEPEND="${DEPEND}
	!!<=dev-rust/libvda-0.0.1-r5
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
