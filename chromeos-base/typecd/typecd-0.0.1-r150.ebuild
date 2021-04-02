# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_WORKON_COMMIT="677f72e3953f7cd55a0d6e1fe59456617bfdb792"
CROS_WORKON_TREE=("ae528dee9890ab7346a1fee2e50877007ea3e1c0" "9d3305545b48fd2834b692a0645dba4eb22d0c99" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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

DEPEND="
	chromeos-base/debugd-client:=
	chromeos-base/system_api:=
"

src_install() {
	dobin "${OUT}"/typecd

	insinto /usr/share/dbus-1/system-services
	doins dbus/org.chromium.typecd.service

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

	# Install D-Bus permission config.
	insinto /etc/dbus-1/system.d
	doins dbus/typecd.conf
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
