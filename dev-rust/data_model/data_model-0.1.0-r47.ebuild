# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="b8e498f743aed439ddbc6f08d342b403c0bed8be"
CROS_WORKON_TREE=("18102c768327557f0707356872e09a7db42fd896" "657879d7112bd65f190dbbf687daca14399681d0")
CROS_WORKON_LOCALNAME="../platform/crosvm"
CROS_WORKON_PROJECT="chromiumos/platform/crosvm"
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_RUST_SUBDIR="common/data_model"
CROS_WORKON_SUBTREE="${CROS_RUST_SUBDIR} .cargo"
CROS_WORKON_SUBDIRS_TO_COPY="${CROS_WORKON_SUBTREE}"

inherit cros-workon cros-rust

DESCRIPTION="Crates includes traits and types for safe interaction with raw memory."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/crosvm/+/HEAD/data_model"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="test"

DEPEND="
	dev-rust/assertions:=
	dev-rust/libc:=
	=dev-rust/remain-0.2*:=
	=dev-rust/serde-1*:=
	>=dev-rust/thiserror-1.0.20:= <dev-rust/thiserror-2.0
"
# (crbug.com/1182669): build-time only deps need to be in RDEPEND so they are pulled in when
# installing binpkgs since the full source tree is required to use the crate.
RDEPEND="${DEPEND}
	!!<=dev-rust/data_model-0.1.0-r13
"
