# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="af210150e106c57c50af35f52d6ed0f7e6d5807a"
CROS_WORKON_TREE=("0e0096e2f807dd76319ca60851fd01ddd44ec580" "9ea474d737512098f2b4a016ca37ab550519ce6b")
CROS_WORKON_LOCALNAME="../platform/crosvm"
CROS_WORKON_PROJECT="chromiumos/platform/crosvm"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_RUST_SUBDIR="common/assertions"
CROS_WORKON_SUBTREE="${CROS_RUST_SUBDIR} .cargo"
CROS_WORKON_SUBDIRS_TO_COPY="${CROS_WORKON_SUBTREE}"

inherit cros-workon cros-rust

DESCRIPTION="Crates for compile-time assertion macro."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/crosvm/+/HEAD/assertions"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="test"

RDEPEND="!!<=dev-rust/assertions-0.1.0-r3"
