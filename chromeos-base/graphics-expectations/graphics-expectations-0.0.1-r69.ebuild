# Copyright 2020 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_WORKON_COMMIT="df66c3b03fc676b974976faa408858c042fc4897"
CROS_WORKON_TREE="f6d814dfd4dd33a3c077f9c80b2649efbe35d18c"
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
