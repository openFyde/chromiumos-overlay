# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_WORKON_COMMIT="57779f9c27d62896f66cced9cc88443ae9585372"
CROS_WORKON_TREE=("52a8a8b6d3bbca5e90d4761aa308a5541d52b1bb" "db70efe3fd2e7a879ce410187a6d719ee6d38ac8" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_DESTDIR="${S}/platform2"
CROS_WORKON_SUBTREE="common-mk typecd .gn"

PLATFORM_SUBDIR="typecd"

inherit cros-workon platform user

DESCRIPTION="Chrome OS USB Type C daemon"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/typecd/"

LICENSE="BSD-Google"
SLOT=0
KEYWORDS="*"
IUSE="+seccomp"

src_install() {
	dobin "${OUT}"/typecd

	insinto /etc/init
	doins init/*.conf

	# Install seccomp policy file.
	insinto /usr/share/policy
	use seccomp && newins "seccomp/typecd-seccomp-${ARCH}.policy" typecd-seccomp.policy

	# Install rsyslog config.
	insinto /etc/rsyslog.d
	doins rsyslog/rsyslog.typecd.conf
}

pkg_preinst() {
	enewuser typecd
	enewgroup typecd
}

platform_pkg_test() {
	platform_test "run" "${OUT}/typecd_testrunner"
}
