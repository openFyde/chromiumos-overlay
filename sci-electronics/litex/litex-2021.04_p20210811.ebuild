# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6..9} )
DISTUTILS_USE_SETUPTOOLS=rdepend
inherit distutils-r1

DESCRIPTION="The LiteX framework provides a convenient and efficient infrastructure to
create FPGA Cores/SOCs, to create FPGA Cores/SoCs, to explore various digital design
architectures and create full FPGA based systems."
HOMEPAGE="https://github.com/enjoy-digital/litex"

GIT_REV="ab9f214a5ee4ab5bf96e19ff3520cf59092ad11a"
SRC_URI="https://github.com/enjoy-digital/${PN}/archive/${GIT_REV}.tar.gz -> ${PN}-${GIT_REV}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="*"

RDEPEND="
	sci-electronics/migen[${PYTHON_USEDEP}]
	sci-electronics/pythondata-software-compiler_rt[${PYTHON_USEDEP}]
	dev-python/pyserial[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
"

S="${WORKDIR}/${PN}-${GIT_REV}"

PATCHES="
	${FILESDIR}/litex-2021.04_p20210811-add-riscv-cros-elf-to-known-riscv-toolchains.patch
	${FILESDIR}/litex-2021.04_p20210811-disable-build-id-building-bios.patch
	${FILESDIR}/litex-2021.04_p20210811-fix-interconnect-param_layout-bug.patch
"

distutils_enable_tests unittest

src_test() {
	# ECC tests require 'litedram' which in turn requires 'litex' for testing.
	# Let's just skip them.
	mv test/{,skipped-}test_ecc.py || die

	distutils-r1_src_test
}
