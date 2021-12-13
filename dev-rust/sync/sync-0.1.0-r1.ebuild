# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="e7c903fa30a8d616e9140a39d1289da9a36390cb"
CROS_WORKON_TREE="af21c512e6b9981138e4df7664dab87bf004b04b"
CROS_WORKON_LOCALNAME="../platform/crosvm"
CROS_WORKON_PROJECT="chromiumos/platform/crosvm"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_RUST_SUBDIR="common/sync"
CROS_WORKON_SUBTREE="${CROS_RUST_SUBDIR}"
CROS_WORKON_SUBDIRS_TO_COPY="${CROS_RUST_SUBDIR}"

inherit cros-workon cros-rust

DESCRIPTION="Containing a type sync::Mutex which wraps the standard library Mutex and mirrors the same methods"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/crosvm/+/HEAD/sync"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="test"

RDEPEND="!!<=dev-rust/sync-0.1.0-r6"
