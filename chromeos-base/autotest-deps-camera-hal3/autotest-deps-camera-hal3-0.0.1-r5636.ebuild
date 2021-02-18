# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5
CROS_WORKON_COMMIT="a6fbc0b9f4d961186d92bc3f73807ce73ea90251"
CROS_WORKON_TREE="c1c68a89fd83a097d02a1eefa2b613887c405c90"
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
