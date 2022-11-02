# Copyright 2020 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_WORKON_COMMIT="6e21cf843937107f5ea7b11ebecd9ed940ce288e"
CROS_WORKON_TREE="a027d69e72639abdf9255d81f753391c7dd07f22"
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
