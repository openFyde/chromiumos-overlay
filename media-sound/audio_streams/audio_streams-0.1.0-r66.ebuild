# Copyright 2019 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_WORKON_COMMIT="bf16d3536a5aecd1f72998e59d835f9df46b7122"
CROS_WORKON_TREE=("5f03965db3d182870d94d512deee3f9543d140e1" "fa91eb24f5d1f5d37f2b8765977fb8a265c0f9a6")
CROS_WORKON_LOCALNAME="../platform/crosvm"
CROS_WORKON_PROJECT="chromiumos/platform/crosvm"
CROS_WORKON_EGIT_BRANCH="chromeos"
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
	=dev-rust/async-trait-0.1*
	=dev-rust/futures-0.3*
	=dev-rust/remain-0.2*
	dev-rust/serde_json
	dev-rust/sync:=
	dev-rust/sys_util:=
	=dev-rust/thiserror-1*
"
# (crbug.com/1182669): build-time only deps need to be in RDEPEND so they are pulled in when
# installing binpkgs since the full source tree is required to use the crate.
RDEPEND="${DEPEND}
	!<=media-sound/audio_streams-0.1.0-r49
"
