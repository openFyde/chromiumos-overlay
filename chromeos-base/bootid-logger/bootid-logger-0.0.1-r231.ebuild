# Copyright 2020 The ChromiumOS Authors
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=7
CROS_WORKON_COMMIT="2116bcb023ce61186eb5899c5641a24be51d4b48"
CROS_WORKON_TREE=("9706471f3befaf4968d37632c5fd733272ed2ec9" "3828969eba37b28aa25669c1f46daa118a8369ed" "ac99811b8d5ce0ddbb6ef3ce8dc36a0e3153ffae" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
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

	insinto /etc/init
	doins log-bootid-on-boot.conf

	local fuzzer_component_id="1029735"
	platform_fuzzer_install "${S}"/../croslog/OWNERS "${OUT}"/bootid_logger_fuzzer \
		--comp "${fuzzer_component_id}"
}

platform_pkg_test() {
	platform test_all
}
