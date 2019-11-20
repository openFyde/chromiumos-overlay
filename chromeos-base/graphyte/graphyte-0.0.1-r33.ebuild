# Copyright 2016 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="5"
CROS_WORKON_COMMIT="fb22c5af6218f7fe048e0a4b782f4de25f6d630e"
CROS_WORKON_TREE="1aee834a5242d6aab30fca83913aa7ba8faa3178"
CROS_WORKON_PROJECT="chromiumos/graphyte"
CROS_WORKON_LOCALNAME="graphyte"
PYTHON_COMPAT=( python2_7 )

inherit cros-workon distutils-r1

DESCRIPTION="Graphyte RF testing framework"
HOMEPAGE="https://sites.google.com/a/google.com/graphyte/home"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"

RDEPEND=""
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
