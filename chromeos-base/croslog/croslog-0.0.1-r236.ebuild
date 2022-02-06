# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=7
CROS_WORKON_COMMIT="4c66028160989449364d1ce3de6432e2660a151b"
CROS_WORKON_TREE=("b4c941de5ccd331283b7b8fd7f05bfb423285edd" "8fed3696650e5268de1d3b665ecb9737951db46a" "7bd2393837bc4162899abba0a3c6977b462df042" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_SUBTREE="common-mk croslog metrics .gn"

PLATFORM_SUBDIR="croslog"

inherit cros-workon platform

DESCRIPTION="Log viewer for Chromium OS"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/croslog"

LICENSE="BSD-Google"
SLOT="0/0"
KEYWORDS="*"
IUSE=""

DEPEND="
	>=chromeos-base/metrics-0.0.1-r3152:=
	"

src_install() {
	platform_install

	local fuzzer_component_id="931982"
	platform_fuzzer_install "${S}"/OWNERS "${OUT}"/croslog_log_parser_fuzzer \
			--comp "${fuzzer_component_id}"
}

platform_pkg_test() {
	platform test_all
}
