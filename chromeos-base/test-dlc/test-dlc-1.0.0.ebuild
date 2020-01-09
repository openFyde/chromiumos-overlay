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
	local n
	for n in {1..2}; do
		local id="test${n}-dlc"
		local package="test-package"
		insinto "/opt/google/dlc/${id}/${package}/"
		doins "${FILESDIR}/${id}/${package}/table"
		doins "${FILESDIR}/${id}/${package}/imageloader.json"
		insinto "/usr/local/dlc/"
		newins "${FILESDIR}/${id}/${package}/dlcservice_test-dlc.payload" \
			"${id}_${package}_dlcservice_test-dlc.payload"
		newins "${FILESDIR}/${id}/${package}/dlcservice_test-dlc.payload.json" \
			"${id}_${package}_dlcservice_test-dlc.payload.json"
	done
}
