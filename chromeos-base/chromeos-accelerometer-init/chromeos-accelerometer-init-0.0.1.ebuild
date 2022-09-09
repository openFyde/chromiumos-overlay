# Copyright 2014 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Chrome OS trigger allowing chrome to access cros-ec-accel device"
HOMEPAGE="https://dev.chromium.org/chromium-os"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"

RDEPEND="
	!chromeos-base/iioservice
	chromeos-base/mems_setup
	virtual/chromeos-ec-driver-init
	virtual/udev
"

S=${WORKDIR}

src_install() {
	insinto /etc/init
	doins "${FILESDIR}"/init/cros-ec-accel.conf
}
