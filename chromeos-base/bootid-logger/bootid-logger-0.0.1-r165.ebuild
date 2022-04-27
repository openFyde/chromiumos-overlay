# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=7
CROS_WORKON_COMMIT="c90c8001d0c12301969c6945cabd829187053c57"
CROS_WORKON_TREE=("13ac052b68cb3d3a7c63d4dc220532a8c06c1e84" "83ca22e88798e1cc90cb146bff627f7dca4893bc" "e7e51c2ac48332fb4d0e4c08d3829ffaf530b768" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
	platform_install

	insinto /etc/init
	doins log-bootid-on-boot.conf

	local fuzzer_component_id="1029735"
	platform_fuzzer_install "${S}"/../croslog/OWNERS "${OUT}"/bootid_logger_fuzzer \
		--comp "${fuzzer_component_id}"
}

platform_pkg_test() {
	platform test_all
}
