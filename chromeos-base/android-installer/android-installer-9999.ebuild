# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2.

EAPI=7

CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_SUBTREE="arc/android-installer"

PYTHON_COMPAT=(python3_{6,7,8})

inherit cros-workon distutils-r1

DESCRIPTION="Android Installer for Chrome OS"
LICENSE="BSD-Google"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/refs/heads/master/arc/android-installer/"
SLOT="0"
KEYWORDS="~*"

BDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

distutils_enable_tests unittest

src_compile() {
	S+="/${CROS_WORKON_SUBTREE}"
	cd "${S}" || die "This should never happen"
	distutils-r1_src_compile
}
