# Copyright 2020 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_WORKON_COMMIT="65dbc0cc75f1cfa80a2f7ff4bb8f0d836d2a1fd3"
CROS_WORKON_TREE="65899c6e6d107b4c04761190622285cef81bc298"
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
