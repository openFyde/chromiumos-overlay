# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_WORKON_COMMIT="3895458e509fff79d336fec8d220d352e8cad041"
CROS_WORKON_TREE=("c9d6c04f4943607a13f8f0f67bfe3877328898b9" "a920b8bc18a923d5cfa6abfb5390bc903526beef")
CROS_WORKON_LOCALNAME="../platform/crosvm"
CROS_WORKON_PROJECT="chromiumos/platform/crosvm"
# We don't use CROS_WORKON_OUTOFTREE_BUILD here since audio_streams/Cargo.toml
# is using "provided by ebuild" macro which supported by cros-rust
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_RUST_SUBDIR="common/audio_streams"
CROS_WORKON_SUBDIRS_TO_COPY=("${CROS_RUST_SUBDIR}" .cargo)
CROS_WORKON_SUBTREE="${CROS_WORKON_SUBDIRS_TO_COPY[*]}"

inherit cros-workon cros-rust

DESCRIPTION="Crate provides a basic interface for playing audio."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/third_party/adhd/+/HEAD/audio_streams"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="test"

DEPEND="
	=dev-rust/async-trait-0.1*:=
	=dev-rust/futures-0.3*:=
	=dev-rust/remain-0.2*:=
	dev-rust/sync:=
	dev-rust/sys_util:=
	=dev-rust/thiserror-1*:=
"
# (crbug.com/1182669): build-time only deps need to be in RDEPEND so they are pulled in when
# installing binpkgs since the full source tree is required to use the crate.
RDEPEND="${DEPEND}
	!<=media-sound/audio_streams-0.1.0-r49
"
