# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6..9} )
inherit distutils-r1

DESCRIPTION="LiteSPI provides a small footprint and configurable SPI core."
HOMEPAGE="https://github.com/litex-hub/litespi"

GIT_REV="a2a25c09e050b97f8d121d8eb9b18d601f4dc3b7"
SRC_URI="https://github.com/litex-hub/${PN}/archive/${GIT_REV}.tar.gz -> ${PN}-${GIT_REV}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="*"

RDEPEND="
	sci-electronics/litex[${PYTHON_USEDEP}]
	sci-electronics/migen[${PYTHON_USEDEP}]
"

S="${WORKDIR}/${PN}-${GIT_REV}"

distutils_enable_tests unittest
