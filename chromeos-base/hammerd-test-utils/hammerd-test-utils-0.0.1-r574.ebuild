# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="e1136864b979876f04722d251d65bc1cd6b8b1fd"
CROS_WORKON_TREE=("5d60482b48f8f1830a6ee93a1eccf295fd3bd41a" "891f4aa6abe89e837cbebfcfe5cd0cdfe88fdfe2" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_DESTDIR="${S}/platform2"
CROS_WORKON_SUBTREE="common-mk hammerd .gn"

PLATFORM_SUBDIR="hammerd"

PYTHON_COMPAT=( python3_{6..8} )

inherit cros-workon platform distutils-r1

DESCRIPTION="Python wrapper of hammerd API and some python utility scripts."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/hammerd/"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="+hammerd_api"

BDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
"
RDEPEND="
	chromeos-base/hammerd:=
"
DEPEND="${RDEPEND}"

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
	cp -R "${S}/hammertests" "${D}/usr/local/bin"
}
