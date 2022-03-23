# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT="6a23252626f6d8352c4bbb352d86a39a0c45515d"
CROS_WORKON_TREE="de794335f78a4a70b2373a4061e354b3ad5266dc"
PYTHON_COMPAT=( python2_7 python{3_6,3_7,3_8} )

CROS_WORKON_PROJECT="chromiumos/third_party/autotest"
CROS_WORKON_LOCALNAME="third_party/autotest/files"

inherit cros-workon autotest-deponly python-any-r1

DESCRIPTION="Dependencies for camera_HAL3 autotest"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/third_party/autotest/"
LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"

# Autotest enabled by default.
IUSE="+autotest"

AUTOTEST_DEPS_LIST="camera_hal3"

RDEPEND="
	media-libs/cros-camera-test
"

DEPEND="${RDEPEND}"
