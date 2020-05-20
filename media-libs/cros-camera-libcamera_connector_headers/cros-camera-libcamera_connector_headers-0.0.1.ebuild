# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Installs header files for cros-camera-libcamera_connector."
SRC_URI="gs://chromeos-localmirror/distfiles/${P}.tar.gz"

LICENSE="LICENSE.corel"
SLOT="0"
KEYWORDS="*"
IUSE=""
S="${WORKDIR}/${PN}"

src_install() {
	insinto "/usr/include/cros-camera"
	doins "camera_service_connector.h"
}

