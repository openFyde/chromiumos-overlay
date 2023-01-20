# Copyright 2014 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit tmpfiles

DESCRIPTION="Install the upstart job that launches avahi."
HOMEPAGE="http://www.chromium.org/"
LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE="wifi_bootstrapping zeroconf"

RDEPEND="
	net-dns/avahi
"

S=${WORKDIR}

src_install() {
	insinto /etc/init
	if use wifi_bootstrapping || use zeroconf ; then
		newins "${FILESDIR}"/init/auto.conf avahi.conf
	else
		newins "${FILESDIR}"/init/manual.conf avahi.conf
	fi
	newins "${FILESDIR}"/init/cgroup.conf avahi-cgroup.conf
	newtmpfiles "${FILESDIR}/tmpfiles.conf" avahi.conf
}
