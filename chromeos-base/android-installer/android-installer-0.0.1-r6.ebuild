# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2.

EAPI=7

CROS_WORKON_COMMIT="8d996397d3d660327d2123dca8efdeeeadd01711"
CROS_WORKON_TREE="096e46695d63714714d945b5b9e8378beb18891c"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_SUBTREE="arc/android-installer"

PYTHON_COMPAT=(python3_{6,7,8})

inherit cros-workon distutils-r1

DESCRIPTION="Android Installer for Chrome OS"
LICENSE="BSD-Google"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/arc/android-installer/"
SLOT="0"
KEYWORDS="*"

BDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

distutils_enable_tests unittest

src_test() {
	distutils-r1_src_test
}

src_compile() {
	S+="/${CROS_WORKON_SUBTREE}"
	cd "${S}" || die "This should never happen"
	distutils-r1_src_compile
}
