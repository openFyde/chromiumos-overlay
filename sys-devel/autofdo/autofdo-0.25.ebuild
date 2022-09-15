# Copyright 2021 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools flag-o-matic cmake

DESCRIPTION="Utility for generating AFDO profiles"
HOMEPAGE="http://gcc.gnu.org/wiki/AutoFDO"
SRC_URI="https://github.com/google/${PN}/archive/${PV}.tar.xz -> ${P}.tar.xz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="*"
IUSE=""

DEPEND="dev-libs/openssl:0=
	dev-libs/protobuf:=
	dev-libs/libffi
	sys-devel/llvm
	sys-libs/zlib"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-signal_handler-fix-ambigous-max-ar.patch"
)

src_prepare() {
	cmake_src_prepare
}

src_configure() {
	append-ldflags "$(no-as-needed)"
	local mycmakeargs=(
		"-DBUILD_SHARED_LIBS=NO"
		"-DBUILD_TESTING=OFF"
		"-DINSTALL_GTEST=OFF"
		"-DLLVM_PATH=$(llvm-config --cmakedir)"
	)
	cmake_src_configure
}

src_compile() {
	cmake_src_compile create_llvm_prof
}

src_install() {
	AFDO_BUILD_DIR="${WORKDIR}/${P}_build"
	cmake_src_install
	dobin "${AFDO_BUILD_DIR}"/create_llvm_prof "${AFDO_BUILD_DIR}"/profile_merger \
		"${AFDO_BUILD_DIR}"/sample_merger
}
