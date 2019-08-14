# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

CROS_WORKON_COMMIT="301583c01a64cecdf2e96b66c14442f7b0122f49"
CROS_WORKON_TREE="b07ca21e719f39bce322e5e5ee98d60c4b53c0a2"
CROS_WORKON_LOCALNAME="../platform/crosvm"
CROS_WORKON_PROJECT="chromiumos/platform/crosvm"
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_SUBTREE="data_model"
CROS_WORKON_SUBDIRS_TO_COPY="data_model"

inherit cros-workon cros-rust

DESCRIPTION="Crates includes traits and types for safe interaction with raw memory."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/+/master/crosvm/data_model"

LICENSE="BSD-Google"
SLOT="${PV}/${PR}"
KEYWORDS="*"
IUSE="test"

DEPEND="
	dev-rust/assertions:=
"

src_unpack() {
	cros-workon_src_unpack
	S+="/data_model"

	cros-rust_src_unpack
}

src_compile() {
	use test && ecargo_test --no-run
}

src_test() {
	if use x86 || use amd64; then
		ecargo_test
	else
		elog "Skipping rust unit tests on non-x86 platform"
	fi
}

src_install() {
	cros-rust_publish "${PN}" "$(cros-rust_get_crate_version)"
}
