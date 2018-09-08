# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT="5f27649cb24a11fd887c61ab61df275b6a702587"
CROS_WORKON_TREE=("56c75aa73108d344f9441f26855f37e4c4838dd3" "cf5be6aaf1a75288c6e64548b5f79ef8a6ec80d2" "dc1506ef7c8cfd2c5ffd1809dac05596ec18773c")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_DESTDIR="${S}/platform2"
CROS_WORKON_SUBTREE="common-mk hammerd .gn"

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

	# Install hammer base tests on dut
	dodir /usr/local/bin/hammertests
	cp -R "${S}/hammertests" "${D}/usr/local/bin/hammertests"
}
