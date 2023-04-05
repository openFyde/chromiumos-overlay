# Copyright 2019 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_WORKON_COMMIT="37e9941ffa778bef80f56b959cfdf2e7d5008c5b"
CROS_WORKON_TREE="90e3583ed349a46aa431d1594d247d3ac9056f64"
CROS_RUST_SUBDIR="."

CROS_WORKON_LOCALNAME="adhd"
CROS_WORKON_PROJECT="chromiumos/third_party/adhd"
# We don't use CROS_WORKON_OUTOFTREE_BUILD here since cras/src/server/rust is
# using the `provided by ebuild` macro from the cros-rust eclass

inherit cros-workon cros-rust

DESCRIPTION="Rust code which is used within cras"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/third_party/adhd/+/HEAD"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="dlc test"

DEPEND="
	dev-rust/third-party-crates-src:=
	dev-rust/system_api:=
	sys-apps/dbus:=
"
# (crbug.com/1182669): build-time only deps need to be in RDEPEND so they are pulled in when
# installing binpkgs since the full source tree is required to use the crate.
RDEPEND="
	${DEPEND}
	!media-sound/audio_processor
"

src_compile() {
	local features=(
		$(usex dlc cras_dlc "")
	)
	cros-rust_src_compile --features="${features[*]}" --workspace
}

src_test() {
	local features=(
		$(usex dlc cras_dlc "")
	)
	cros-rust_src_test --features="${features[*]}" --workspace
}

src_install() {
	dolib.a "$(cros-rust_get_build_dir)/libcras_rust.a"

	# Install to /usr/local so they are stripped out of the release image.
	into /usr/local
	dobin "$(cros-rust_get_build_dir)/offline-pipeline"
}
