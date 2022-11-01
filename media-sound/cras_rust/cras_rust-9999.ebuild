# Copyright 2019 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_RUST_SUBDIR="cras/src/server/rust"

CROS_WORKON_LOCALNAME="adhd"
CROS_WORKON_PROJECT="chromiumos/third_party/adhd"
# We don't use CROS_WORKON_OUTOFTREE_BUILD here since cras/src/server/rust is
# using the `provided by ebuild` macro from the cros-rust eclass
CROS_WORKON_SUBTREE="${CROS_RUST_SUBDIR}"

inherit cros-workon cros-rust

DESCRIPTION="Rust code which is used within cras"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/third_party/adhd/+/HEAD/cras/src/server/rust"

LICENSE="BSD-Google"
KEYWORDS="~*"
IUSE="dlc test"

DEPEND="
	dev-rust/third-party-crates-src:=
	=dev-rust/dbus-0.9*
	>=dev-rust/protobuf-2.16.2 <dev-rust/protobuf-3
	dev-rust/system_api:=
	media-sound/audio_processor:=
"
# (crbug.com/1182669): build-time only deps need to be in RDEPEND so they are pulled in when
# installing binpkgs since the full source tree is required to use the crate.
RDEPEND="${DEPEND}"

src_compile() {
	local features=(
		$(usex dlc cras_dlc "")
	)
	cros-rust_src_compile -v --features="${features[*]}"
}

src_install() {
	dolib.a "$(cros-rust_get_build_dir)/libcras_rust.a"
	cros-rust_src_install
}
