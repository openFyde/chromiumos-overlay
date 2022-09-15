# Copyright 2019 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

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
KEYWORDS="~*"
IUSE="test"

DEPEND="
	dev-rust/chromeos-dbus-bindings:=
	>=dev-rust/clap-3.1.12 <dev-rust/clap-4.0
	=dev-rust/dbus-0.9*
	dev-rust/hound
	=dev-rust/serde_json-1*
	dev-rust/sys_util:=
	>=dev-rust/thiserror-1.0.20 <dev-rust/thiserror-2.0
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
