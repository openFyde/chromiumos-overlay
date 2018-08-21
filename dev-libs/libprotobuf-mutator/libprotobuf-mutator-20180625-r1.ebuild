# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit cmake-utils

DESCRIPTION="Library to randomly mutate protobuffers."
HOMEPAGE="https://github.com/google/libprotobuf-mutator"
GIT_REV="c9a1e56750a4eef6ffca95f41f79f06979056e01"
SRC_URI="https://github.com/google/${PN}/archive/${GIT_REV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="*"
IUSE=""

RDEPEND="dev-libs/protobuf:="
DEPEND="${RDEPEND}"

S="${WORKDIR}/${PN}-${GIT_REV}/"

src_configure() {
	local mycmakeargs=(
		-DTHREADS_PTHREAD_ARG=-pthread
	)
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_make protobuf-mutator protobuf-mutator-libfuzzer
}

src_install() {
	insinto /usr/include/libprotobuf-mutator/port
	doins port/*.h
	insinto /usr/include/libprotobuf-mutator/src
	doins src/*.h
	insinto /usr/include/libprotobuf-mutator/src/libfuzzer
	doins src/libfuzzer/*.h

	insinto /usr/share/pkgconfig
	doins "${FILESDIR}/${PN}.pc"

	dolib.a "${BUILD_DIR}/src/libprotobuf-mutator.a"
	dolib.a "${BUILD_DIR}/src/libfuzzer/libprotobuf-mutator-libfuzzer.a"
}
