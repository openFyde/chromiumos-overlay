# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT="aad546f2a06fd7cbc9f00c573d33f2e2a4402afb"
CROS_WORKON_TREE=("ce18fba0c0aae39b3917fd9511c2a282b7fb703b" "3557b75adb050b9c9cc960b317b10d7fd7ef94ac")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_DESTDIR="${S}/platform2"
CROS_WORKON_SUBTREE="common-mk hammerd"

PLATFORM_SUBDIR="hammerd"

PYTHON_COMPAT=( python2_7 )

inherit cros-workon platform distutils-r1

DESCRIPTION="Python wrapper of hammerd API and some python utility scripts."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/hammerd/"

LICENSE="BSD-Google"
SLOT=0
KEYWORDS="*"
IUSE="+hammerd_api"

RDEPEND="
	chromeos-base/hammerd
"
DEPEND="
	${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
"

src_configure() {
	platform_src_configure
	distutils-r1_src_configure
}

src_compile() {
	platform_src_compile
	distutils-r1_src_compile
}

src_install() {
	# Install exposed API.
	dolib.so "${OUT}"/lib/libhammerd-api.so
	insinto /usr/include/hammerd/
	doins hammerd_api.h
	distutils-r1_src_install
}
