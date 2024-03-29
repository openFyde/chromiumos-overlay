# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="7"
PYTHON_COMPAT=( python3_{6..8} )

inherit distutils-r1

DESCRIPTION="Fast, simple packet creation / parsing"
HOMEPAGE="https://github.com/kbandla/dpkt"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="*"
