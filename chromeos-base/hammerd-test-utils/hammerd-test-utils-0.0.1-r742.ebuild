# Copyright 2017 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="569acd1eb0e5ee39f1e4b50921a0856c0b30f137"
CROS_WORKON_TREE=("0c3a30cd50ce72094fbd880f2d16d449139646a2" "f0474d90fb5e5de06d29ddc7bcd55c31fd6e815a" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_DESTDIR="${S}/platform2"
CROS_WORKON_SUBTREE="common-mk hammerd .gn"

PLATFORM_SUBDIR="hammerd"

PYTHON_COMPAT=( python3_{6..9} )

inherit cros-workon platform distutils-r1

DESCRIPTION="Python wrapper of hammerd API and some python utility scripts."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/hammerd/"

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
	# platform_src_install omitted, to avoid conflicts with
	# chromeos-base/hammerd.

	# Install exposed API.
	dolib.so "${OUT}"/lib/libhammerd-api.so
	insinto /usr/include/hammerd/
	doins hammerd_api.h
	distutils-r1_src_install

	# Install hammer base tests on dut
	dodir /usr/local/bin/hammertests
	cp -R "${S}/hammertests" "${D}/usr/local/bin"
}
