# Copyright 2020 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_WORKON_COMMIT="e18a4f4fff87e9aaed0aa21e2182d44220dbbcf4"
CROS_WORKON_TREE="332e8903755da1f97ed2ec7d5c3f4eef02688297"
CROS_WORKON_PROJECT="chromiumos/platform/graphics"
CROS_WORKON_LOCALNAME="platform/graphics"

inherit cros-workon

DESCRIPTION="Installs shared expectations for graphics tests."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/graphics/"

LICENSE="BSD-Google"
SLOT=0
KEYWORDS="*"
IUSE=""

RDEPEND=""

DEPEND="
	${RDEPEND}
"

BDEPEND=""

INSTALL_DIR="/usr/local/graphics"

src_unpack() {
	cros-workon_src_unpack
}

src_install() {
	insinto "${INSTALL_DIR}"
	doins -r expectations
}
