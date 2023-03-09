# Copyright 2019 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_WORKON_COMMIT="4e6e9e38c36c7df1996289fa7859546e941ab976"
CROS_WORKON_TREE="cbf6a3a1d5275bfd9fce29fc5c0910949087f1e0"
CROS_RUST_SUBDIR="cras/src/server/rust"

CROS_WORKON_LOCALNAME="adhd"
CROS_WORKON_PROJECT="chromiumos/third_party/adhd"
# We don't use CROS_WORKON_OUTOFTREE_BUILD here since cras/src/server/rust is
# using the `provided by ebuild` macro from the cros-rust eclass
CROS_WORKON_SUBTREE="cras/src"

inherit cros-workon cros-rust

DESCRIPTION="Rust code which is used within cras"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/third_party/adhd/+/HEAD/cras/src/server/rust"

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
RDEPEND="${DEPEND}"

src_compile() {
	local features=(
		$(usex dlc cras_dlc "")
	)
	cros-rust_src_compile -v --features="${features[*]}" \
		--package=cras_rust --package=audio_processor
}

src_install() {
	dolib.a "$(cros-rust_get_build_dir)/libcras_rust.a"

	# Install to /usr/local so they are stripped out of the release image.
	into /usr/local
	dobin "$(cros-rust_get_build_dir)/offline-pipeline"
}
