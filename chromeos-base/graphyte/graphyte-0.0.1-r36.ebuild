# Copyright 2016 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="3acbab67202baa3d7b298601b37ebf61d03edc7c"
CROS_WORKON_TREE="3f4cc1937d9265126a405f39d7abff654605866c"
CROS_WORKON_PROJECT="chromiumos/graphyte"
CROS_WORKON_LOCALNAME="graphyte"
PYTHON_COMPAT=( python2_7 )

inherit cros-workon distutils-r1

DESCRIPTION="Graphyte RF testing framework"
HOMEPAGE="https://sites.google.com/a/google.com/graphyte/home"

LICENSE="BSD-Google"
KEYWORDS="*"

RDEPEND=""
BDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
