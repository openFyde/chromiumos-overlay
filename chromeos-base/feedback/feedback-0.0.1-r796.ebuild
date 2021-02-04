# Copyright 2014 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="f94fa4ae6da723e39c479c9414b28f0d2e29d0c4"
CROS_WORKON_TREE=("6aefce87a7cf5e4abd0f0466c5fa211f685a1193" "53956281966054116af6855ac4e859d6eb6533d7" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_DESTDIR="${S}/platform2"
CROS_WORKON_SUBTREE="common-mk feedback .gn"

PLATFORM_SUBDIR="feedback"

inherit cros-constants cros-workon git-2 platform

DESCRIPTION="Feedback service for Chromium OS"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/feedback/"
LICENSE="BSD-Google"
KEYWORDS="*"

RDEPEND=""
DEPEND="chromeos-base/system_api:="

src_install() {
	dobin "${OUT}"/feedback_client
	dobin "${OUT}"/feedback_daemon

	insinto /etc/init
	doins init/feedback_daemon.conf

	insinto /etc/dbus-1/system.d
	doins org.chromium.feedback.conf

	insinto /usr/include/feedback
	doins components/feedback/feedback_common.h
	doins feedback_service_interface.h
}

platform_pkg_test() {
	local tests=(
		feedback_daemon_test
	)

	local test_bin
	for test_bin in "${tests[@]}"; do
		platform_test "run" "${OUT}/${test_bin}"
	done
}
