# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_WORKON_COMMIT="ef6239b2adc593ced44e19680591e666843f2d3b"
CROS_WORKON_TREE=("52a8a8b6d3bbca5e90d4761aa308a5541d52b1bb" "5d3b421c3dfc0a00ae58d410eae1c4d84d5d78fd" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_DESTDIR="${S}/platform2"
CROS_WORKON_SUBTREE="common-mk typecd .gn"

PLATFORM_SUBDIR="typecd"

inherit cros-workon platform user

DESCRIPTION="Chrome OS USB Type C daemon"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/typecd/"

LICENSE="BSD-Google"
SLOT=0
KEYWORDS="*"
IUSE="+seccomp"

src_install() {
	dobin "${OUT}"/typecd

	insinto /etc/init
	doins init/*.conf

	# Install seccomp policy files.
	insinto /usr/share/policy
	if use seccomp; then
		newins "seccomp/typecd-seccomp-${ARCH}.policy" typecd-seccomp.policy
		newins "seccomp/ectool_typec-seccomp-${ARCH}.policy" ectool_typec-seccomp.policy
	fi

	# Install rsyslog config.
	insinto /etc/rsyslog.d
	doins rsyslog/rsyslog.typecd.conf
}

pkg_preinst() {
	enewuser typecd
	enewgroup typecd

	# This group is required for debugd EC Type C tool to access /dev/cros_ec.
	enewgroup cros_ec-access
	# Add user and group for debugd Type C commands.
	enewuser typecd_ec
	enewgroup typecd_ec
}

platform_pkg_test() {
	platform_test "run" "${OUT}/typecd_testrunner"
}
