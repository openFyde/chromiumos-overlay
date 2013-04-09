# Copyright (c) 2013 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="4"
CROS_WORKON_COMMIT="1edbfb369f7bb7981dab635f9bcb40cc93f9e6a2"
CROS_WORKON_TREE="946db750191b11e8d16e04ed8e90c73c36e90010"
CROS_WORKON_PROJECT="chromiumos/platform/init"
CROS_WORKON_LOCALNAME="init"

inherit cros-workon

DESCRIPTION="Upstart jobs that will be installed on embedded CrOS images"
HOMEPAGE="http://www.chromium.org/"
LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm x86"
IUSE="+vt"

DEPEND=""
RDEPEND="${DEPEND}
	sys-apps/rootdev
	sys-apps/upstart
"

src_install() {
	into /	# We want /sbin, not /usr/sbin, etc.

	# Install Upstart configuration files.
	dodir /etc/init
	insinto /etc/init
	doins startup.conf
	doins embedded-init/boot-services.conf
	doins embedded-init/login-prompt-visible.conf

	doins boot-complete.conf cgroups.conf crash-reporter.conf cron-lite.conf
	doins dbus.conf failsafe-delay.conf failsafe.conf halt.conf
	doins install-completed.conf ip6tables.conf iptables.conf
	doins pre-shutdown.conf pstore.conf reboot.conf shill.conf
	doins shill_respawn.conf syslog.conf system-services.conf tlsdated.conf
	doins update-engine.conf wpasupplicant.conf

	use vt && doins tty2.conf

	insinto /etc
	doins issue rsyslog.chromeos

	# Install startup/shutdown scripts.
	dosbin "${S}/embedded-init/chromeos_startup"
	dosbin "${S}/embedded-init/chromeos_shutdown"

	# Install log cleaning script and run it daily.
	into /usr
	dosbin chromeos-cleanup-logs
}
