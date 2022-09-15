# Copyright 2021 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=( python2_7 python3_{6..9} )
inherit distutils-r1

DESCRIPTION="Generic automation framework for acceptance testing and robotic
process automation (RPA)"
HOMEPAGE="https://robotframework.org/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.zip"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="*"
