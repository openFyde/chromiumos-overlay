# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="A test Downloadable Content (DLC) module for DLC tast tests"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/dlcservice"
SRC_URI=""

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE="dlc"
REQUIRED_USE="dlc"

src_unpack() {
	# Makes emerge pass.
	S="${WORKDIR}"
}

src_install() {
	# Installs test DLC module.
	insinto /opt/google/dlc/test-dlc/
	doins "${FILESDIR}/table"
	doins "${FILESDIR}/imageloader.json"
	insinto /usr/local/dlc/
	doins "${FILESDIR}/dlcservice_test-dlc.payload"
}
