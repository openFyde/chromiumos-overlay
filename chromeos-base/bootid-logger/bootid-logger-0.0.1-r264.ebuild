# Copyright 2020 The ChromiumOS Authors
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=7
CROS_WORKON_COMMIT="db50fe0ee6a2e2756fd40d261155c240548ad26b"
CROS_WORKON_TREE=("92a7718bfe5a15c594fcc6b0855e68b0981cd9a0" "d321d25c9d08d4f99fb44cee7f41a53e768ba406" "b2a83c3f1f4ab3e926ff79e0f493c587ddb943d1" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_SUBTREE="common-mk bootid-logger croslog .gn"

PLATFORM_SUBDIR="bootid-logger"

inherit cros-workon platform

DESCRIPTION="Program to record the current boot ID to the log"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/bootid-logger"

LICENSE="BSD-Google"
SLOT="0/0"
KEYWORDS="*"
IUSE=""

RDEPEND=">=chromeos-base/croslog-0.0.1-r45"

DEPEND="${RDEPEND}"

src_install() {
	platform_src_install

	local fuzzer_component_id="1029735"
	platform_fuzzer_install "${S}"/../croslog/OWNERS "${OUT}"/bootid_logger_fuzzer \
		--comp "${fuzzer_component_id}"
}

platform_pkg_test() {
	platform test_all
}
