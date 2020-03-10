# Copyright 2016 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="dbaec98fc97ebbbf2aa3ac81ee3f4502a55a4038"
CROS_WORKON_TREE="068a93a9d64357042300153808eb9309ee5fee5c"
CROS_WORKON_PROJECT="chromiumos/graphyte"
CROS_WORKON_LOCALNAME="platform/graphyte"
PYTHON_COMPAT=( python2_7 python3_{6,7} )

inherit cros-workon distutils-r1

DESCRIPTION="Graphyte RF testing framework"
HOMEPAGE="https://sites.google.com/a/google.com/graphyte/home"

LICENSE="BSD-Google"
KEYWORDS="*"

RDEPEND=""
BDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
