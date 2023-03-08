# Copyright 2014 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

DESCRIPTION="Install packages that must live in the rootfs in dev images."
HOMEPAGE="http://www.chromium.org/"
KEYWORDS="*"
LICENSE="BSD-Google"
SLOT="0"
IUSE="printscanmgr"

# TODO(b/257070388): Remove the printscanmgr package and its IUSE flag once it
# is being installed in the base image.
RDEPEND="
	chromeos-base/openssh-server-init
	printscanmgr? ( chromeos-base/printscanmgr )
	chromeos-base/virtual-usb-printer
	virtual/chromeos-bsp-dev-root
"
