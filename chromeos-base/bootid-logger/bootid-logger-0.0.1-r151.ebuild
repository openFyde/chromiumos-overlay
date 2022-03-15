# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=7
CROS_WORKON_COMMIT="ddcc94ff34a259fc6b8d47de2096a511ee45a109"
CROS_WORKON_TREE=("38a9b1daf75f7eb99a4e2bce2be48157069e9a15" "1330141be4bcc5ab6d09f1a06295b97e8e3e1210" "cbfad0a0acc307833b657e8cd64ad0ea1f343357" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
