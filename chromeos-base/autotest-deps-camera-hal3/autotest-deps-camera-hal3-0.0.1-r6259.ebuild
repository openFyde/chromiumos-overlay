# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5
CROS_WORKON_COMMIT="83023d29f336d5852ec8d74b823f0c3aa5167345"
CROS_WORKON_TREE="217ee268a2294144d091a7a15187fc21b4a65af3"
CROS_WORKON_PROJECT="chromiumos/third_party/autotest"
CROS_WORKON_LOCALNAME="third_party/autotest/files"

inherit cros-workon autotest-deponly

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
