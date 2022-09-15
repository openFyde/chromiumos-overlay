# Copyright 2018 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="bf16d3536a5aecd1f72998e59d835f9df46b7122"
CROS_WORKON_TREE=("e07d282788bc8c115ac907aec523e92eaa97a746" "fa91eb24f5d1f5d37f2b8765977fb8a265c0f9a6")
CROS_WORKON_LOCALNAME="../platform/crosvm"
CROS_WORKON_PROJECT="chromiumos/platform/crosvm"
CROS_WORKON_EGIT_BRANCH="chromeos"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_RUST_SUBDIR="common/assertions"
CROS_WORKON_SUBTREE="${CROS_RUST_SUBDIR} .cargo"
CROS_WORKON_SUBDIRS_TO_COPY=(${CROS_WORKON_SUTREE})

inherit cros-workon cros-rust

DESCRIPTION="Crates for compile-time assertion macro."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/crosvm/+/HEAD/assertions"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="test"

RDEPEND="!!<=dev-rust/assertions-0.1.0-r3"
