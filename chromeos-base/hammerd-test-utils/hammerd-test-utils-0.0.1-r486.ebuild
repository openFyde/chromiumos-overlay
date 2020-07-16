# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="0c814ece11a50512bd229dc0ddcec46c698519d0"
CROS_WORKON_TREE=("cf397e9600a0b2d153f579c58419577cfca75ab7" "f2bf6ae043b20c7e134a520985328b7bd10e6481" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
