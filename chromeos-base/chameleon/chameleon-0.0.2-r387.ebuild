# Copyright (c) 2014 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=4
CROS_WORKON_COMMIT="a6cc29ffaba1c836cfb74c6d2d505c1944194d65"
CROS_WORKON_TREE="6525be77c2f0121c9abcead6da2cd5150e227c15"
CROS_WORKON_PROJECT="chromiumos/platform/chameleon"

inherit cros-workon

DESCRIPTION="Chameleon bundle for Autotest lab deployment"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/chameleon/"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE=""

RDEPEND="dev-lang/python"
DEPEND="${RDEPEND}"

src_install() {
	local base_dir="/usr/share/chameleon-bundle"
	insinto "${base_dir}"
	newins dist/chameleond-*.tar.gz chameleond-${PVR}.tar.gz
}
