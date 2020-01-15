# Copyright 2015 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=4
CROS_WORKON_COMMIT="b5b1c4ff66a22d145f9692f90b91326e26c1065c"
CROS_WORKON_TREE="f8c59abe63d4643e1c0f9d299d7d719529dd0b8d"
CROS_WORKON_PROJECT="chromiumos/third_party/autotest"
CROS_WORKON_LOCALNAME="third_party/autotest/files"

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
