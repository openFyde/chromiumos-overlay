# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_WORKON_COMMIT="6ae8fc5c6e9b8cfc268b2b18447114b770229c3b"
CROS_WORKON_TREE="95b75597932a73a3f6a2fb6eb32a171a8362990f"
CROS_WORKON_PROJECT="chromiumos/platform/graphics"
CROS_WORKON_LOCALNAME="platform/graphics"
CROS_WORKON_SUBTREE="src/results_database"

PYTHON_COMPAT=( python3_{6..9} )

inherit cros-workon distutils-r1

DESCRIPTION="Graphics utilities written in python"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/graphics/"

LICENSE="BSD-Google"
SLOT=0
KEYWORDS="*"
IUSE=""

RDEPEND="chromeos-base/cros-config-api"

DEPEND="
	${RDEPEND}
"

BDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
"

src_unpack() {
	cros-workon_src_unpack
	S+="/src/results_database"
}

src_install() {
	dobin bq_insert_pb.py
	dobin generate_trace_info.py
	dobin record_machine_info.py
	dobin record_package_override.py
	dobin record_software_config.py
	dobin summarize_apitrace_log.py

	distutils-r1_src_install
}
