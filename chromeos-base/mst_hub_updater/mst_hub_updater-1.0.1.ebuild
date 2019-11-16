# Copyright 2019 The Chromium OS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Firmware Updater for Realtek DP Multimedia Hub"
SRC_URI="gs://chromeos-localmirror/distfiles/${P}.tar.gz"

LICENSE="BSD-Realtek"
SLOT="0"
KEYWORDS="*"

S="${WORKDIR}/RTIspSourceCodeLinux_V${PV}"

MST_TOOL_INSTALL_PATH="/opt/google/display/mst_hub/tools"

src_configure() {
	cros_enable_cxx_exceptions
}

src_install() {
	emake install
	insinto "${MST_TOOL_INSTALL_PATH}"
	doins -r ReleaseTool/*
	chmod a+x "${D}/${MST_TOOL_INSTALL_PATH}/ISPTool" || die
}
