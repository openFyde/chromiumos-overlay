# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="191444797d415446744b742ebb7eab5e10f08cbc"
CROS_WORKON_TREE="8a5a39267e3e69d4359e4a665e12121ccb3262a7"
CROS_WORKON_LOCALNAME="../platform/crosvm"
CROS_WORKON_PROJECT="chromiumos/platform/crosvm"
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_SUBTREE="data_model"
CROS_WORKON_SUBDIRS_TO_COPY="data_model"

inherit cros-workon cros-rust

DESCRIPTION="Crates includes traits and types for safe interaction with raw memory."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/+/HEAD/crosvm/data_model"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="test"

DEPEND="
	dev-rust/assertions:=
"

RDEPEND="!!<=dev-rust/data_model-0.1.0-r13"
