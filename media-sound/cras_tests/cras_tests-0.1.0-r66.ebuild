# Copyright 2019 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_WORKON_COMMIT="842f702e44407d0999681abf2065e2289142f4a1"
CROS_WORKON_TREE=("53d92083a25fb829e3e9994f0f30a6b82d25ac2b" "06866921ed148ee3c0efad8cdc3b00517edcee38")
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
	dev-rust/libchromeos:=
	media-sound/audio_streams:=
	media-sound/libcras:=
	sys-apps/dbus:=
"
# DEPEND isn't needed in RDEPEND because nothing from this ebuild is installed
# to the cros_rust_registry.
RDEPEND="
	!<=media-sound/cras_tests-0.1.0-r12
"

src_install() {
	dobin "$(cros-rust_get_build_dir)/cras_tests"
}
