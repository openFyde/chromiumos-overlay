# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="4e464ae6abcbf64eb6e9d2e03515608f7ec2ed01"
CROS_WORKON_TREE="00292a2fba7e396556acb9ab02ba72be35663249"
CROS_WORKON_LOCALNAME="../platform/crosvm"
CROS_WORKON_PROJECT="chromiumos/platform/crosvm"
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_SUBTREE="data_model"
CROS_WORKON_SUBDIRS_TO_COPY="data_model"

inherit cros-workon cros-rust

DESCRIPTION="Crates includes traits and types for safe interaction with raw memory."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/+/master/crosvm/data_model"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="test"

DEPEND="
	dev-rust/assertions:=
"

RDEPEND="!!<=dev-rust/data_model-0.1.0-r13"

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
