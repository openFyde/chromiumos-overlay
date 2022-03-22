# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=7
CROS_WORKON_COMMIT="2e5c421c335d5e5750149a486d4b63bc5e158517"
CROS_WORKON_TREE=("beaa23ddfa8fcd0c80807667abfa09780522b3ad" "cbfad0a0acc307833b657e8cd64ad0ea1f343357" "06141645c39782823b463fed307013ef8b02406a" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_SUBTREE="common-mk croslog metrics .gn"

PLATFORM_SUBDIR="croslog"

inherit cros-workon platform

DESCRIPTION="Log viewer for Chromium OS"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/croslog"

LICENSE="BSD-Google"
SLOT="0/0"
KEYWORDS="*"
IUSE=""

DEPEND="
	>=chromeos-base/metrics-0.0.1-r3152:=
	"

src_install() {
	platform_install
	platform_src_install

	local fuzzer_component_id="931982"
	platform_fuzzer_install "${S}"/OWNERS "${OUT}"/croslog_log_parser_fuzzer \
			--comp "${fuzzer_component_id}"
}

platform_pkg_test() {
	platform test_all
}
