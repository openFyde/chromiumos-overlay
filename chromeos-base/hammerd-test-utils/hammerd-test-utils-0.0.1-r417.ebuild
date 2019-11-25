# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="508946ea3be53729eda370d98440d1d6d45bd8f6"
CROS_WORKON_TREE=("1e8218a3d15868b67db7aac03b06e3d7de327778" "7f46a1687fedad1d90ea3489282078b36f809f19" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
	cp -R "${S}/hammertests" "${D}/usr/local/bin/hammertests"
}
