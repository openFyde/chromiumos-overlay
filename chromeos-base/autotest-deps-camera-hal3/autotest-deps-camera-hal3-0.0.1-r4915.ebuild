# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5
CROS_WORKON_COMMIT="a26a9b9302a4156429f21b81ce1a500bb37cdf7c"
CROS_WORKON_TREE="f572a3909c6ee7e1f659a08d5fc557d64887ea0b"
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
