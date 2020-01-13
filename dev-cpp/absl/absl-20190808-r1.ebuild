# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils toolchain-funcs

DESCRIPTION="Abseil - C++ Common Libraries"
HOMEPAGE="https://abseil.io"
SRC_URI="https://github.com/abseil/abseil-cpp/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="*"
IUSE=""

RDEPEND=""
DEPEND=""

S="${WORKDIR}/abseil-cpp-${PV}"
ABSLDIR="${WORKDIR}/${P}_build/absl"

src_compile() {
	cmake-utils_src_compile

	cd "${ABSLDIR}"
	# Combine absl libraries into a single archive.
	(
		echo "CREATE libabsl.a"
		printf 'ADDLIB %s\n' */*.a
		echo "SAVE"
		echo "END"
	) >archive_script
	$(tc-getAR) -M < archive_script || die
}

src_install() {
	cmake-utils_src_install

	dolib.a "${ABSLDIR}/libabsl.a"
}
