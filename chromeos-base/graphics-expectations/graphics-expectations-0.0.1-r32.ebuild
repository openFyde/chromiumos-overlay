# Copyright 2020 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_WORKON_COMMIT="9bcfbf4c5af22173d20c1ae8e38f20f7787d59ca"
CROS_WORKON_TREE="aff6ddd142de8304bce544e03ce248ebc41f33b6"
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
