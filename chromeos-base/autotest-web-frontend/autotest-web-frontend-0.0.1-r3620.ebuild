# Copyright 2015 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=4
CROS_WORKON_COMMIT="510d549336fbd8c2a8ee22e8574dfe1a29cdfe99"
CROS_WORKON_TREE="f16fc4840b52e2807225e87ea5182f5a16972f59"
CROS_WORKON_PROJECT="chromiumos/third_party/autotest"
CROS_WORKON_LOCALNAME=../third_party/autotest/files

inherit cros-workon cros-constants

DESCRIPTION="Autotest server web frontend"
HOMEPAGE="http://dev.chromium.org/chromium-os/testing"
SRC_URI=""
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="*"

RDEPEND="
	!<=chromeos-base/autotest-server-0.0.1-r1260
"

DEPEND=""

AUTOTEST_WORK="${WORKDIR}/autotest-work"
AUTOTEST_BASE="/autotest"

src_prepare() {
	mkdir -p "${AUTOTEST_WORK}"
	cp -fpru "${S}"/* "${AUTOTEST_WORK}/" &>/dev/null
	find "${AUTOTEST_WORK}" -name '*.pyc' -delete

	# Compile the frontend elements.
	"${AUTOTEST_WORK}"/utils/compile_gwt_clients.py -a -e"-Djava.util.prefs.userRoot=/tmp" || die
}

src_configure() {
	cros-workon_src_configure
}

src_install() {
	insinto "${AUTOTEST_BASE}/frontend/client/www"/
	doins -r "${AUTOTEST_WORK}/frontend/client/www"/*
}
