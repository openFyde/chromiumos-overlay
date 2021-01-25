# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_WORKON_COMMIT="8c93b8a6595a0017ad63b655e1a9fb9cb062a621"
CROS_WORKON_TREE=("92fa6c1373050d9593236b88ef883cf2b7d0a85a" "f912e5518d9f11fbea834fb3e20984d8807c7d7a" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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

DEPEND="chromeos-base/debugd-client:="

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
