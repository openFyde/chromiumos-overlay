# Copyright 2019 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_WORKON_COMMIT="9a5989bff2283557f80c55d293af155241533af4"
CROS_WORKON_TREE=("1b753285eaf79c0abd50a05b67f2c7375f8da76a" "c103f0be2397bc622314466d808ae3633c9e50c3")
CROS_RUST_SUBDIR="cras/client/cras_tests"

CROS_WORKON_LOCALNAME="adhd"
CROS_WORKON_PROJECT="chromiumos/third_party/adhd"
# We don't use CROS_WORKON_OUTOFTREE_BUILD here since cras-sys/Cargo.toml is
# using "provided by ebuild" macro which supported by cros-rust
CROS_WORKON_SUBTREE="${CROS_RUST_SUBDIR} cras/dbus_bindings"

inherit cros-workon cros-rust

DESCRIPTION="Rust version cras test client"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/third_party/adhd/+/HEAD/cras/client/cras_tests"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="test"

DEPEND="
	dev-rust/third-party-crates-src:=
	dev-rust/chromeos-dbus-bindings:=
	>=dev-rust/clap-3.1.12 <dev-rust/clap-4.0
	=dev-rust/dbus-0.9*
	dev-rust/libchromeos:=
	=dev-rust/serde_json-1*
	media-sound/audio_streams:=
	media-sound/libcras:=
"
# DEPEND isn't needed in RDEPEND because nothing from this ebuild is installed
# to the cros_rust_registry.
RDEPEND="
	!<=media-sound/cras_tests-0.1.0-r12
"

src_install() {
	dobin "$(cros-rust_get_build_dir)/cras_tests"
}
