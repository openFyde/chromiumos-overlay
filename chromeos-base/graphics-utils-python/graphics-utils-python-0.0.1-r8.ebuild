# Copyright 2020 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_WORKON_COMMIT="93252686c057a2540489570bd285bba8f77cf01c"
CROS_WORKON_TREE="09822c8b1b991c979a80342f521c8ce3b56cc4fe"
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
