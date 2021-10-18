# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_WORKON_COMMIT="e1bfa453855870e5593dd23da4b7a793281cab9c"
CROS_WORKON_TREE="56bbfceb28eba10a19c8b67d2ef61de2c994c382"
CROS_RUST_SUBDIR="cras/client/libcras"

CROS_WORKON_LOCALNAME="adhd"
CROS_WORKON_PROJECT="chromiumos/third_party/adhd"
# We don't use CROS_WORKON_OUTOFTREE_BUILD here since cras-sys/Cargo.toml is
# using "provided by ebuild" macro which supported by cros-rust
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_SUBTREE="${CROS_RUST_SUBDIR}"

inherit cros-workon cros-rust

DESCRIPTION="Rust version libcras"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/third_party/adhd/+/HEAD/cras/client/libcras"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="test"

DEPEND="
	>=dev-rust/libc-0.2.44:=
	>=dev-rust/async-trait-0.1.36:= <dev-rust/async-trait-0.2
	dev-rust/cros_async:=
	dev-rust/data_model:=
	dev-rust/sys_util:=
	media-sound/audio_streams:=
	media-sound/cras-sys:=
"
# (crbug.com/1182669): build-time only deps need to be in RDEPEND so they are pulled in when
# installing binpkgs since the full source tree is required to use the crate.
RDEPEND="${DEPEND}
	!<=media-sound/libcras-0.1.0-r21
"
