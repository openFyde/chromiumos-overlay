# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="2c47301c21a3e4d4dfcfefdd3a576c18aa38c98b"
CROS_WORKON_TREE="fe1c473b2a9fa0ac5caaee9ab1d472686620b7bc"
PYTHON_COMPAT=( python3_{6..8} )

CROS_WORKON_PROJECT="chromiumos/platform/usi-test"
CROS_WORKON_LOCALNAME="platform/usi-test"

inherit cros-workon distutils-r1

DESCRIPTION="Universal Stylus Initiative (USI) Certification Tool"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/usi-test/"
SRC_URI=""

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="-"

RDEPEND="~dev-python/hid-tools-0.2[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}"
