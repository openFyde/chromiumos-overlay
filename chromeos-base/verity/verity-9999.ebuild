# Copyright (c) 2009 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=2
CROS_WORKON_PROJECT="chromiumos/platform/dm-verity"

KEYWORDS="~amd64 ~x86 ~arm"

inherit toolchain-funcs cros-debug cros-workon

DESCRIPTION="File system integrity image generator for Chromium OS."
HOMEPAGE="http://www.chromium.org/"
SRC_URI=""
LICENSE="BSD"
SLOT="0"
IUSE="test valgrind splitdebug"

RDEPEND="test? ( chromeos-base/libchrome )
	 test? ( chromeos-base/libchromeos )
	 dev-libs/openssl"

# qemu use isn't reflected as it is copied into the target
# from the build host environment.
DEPEND="${RDEPEND}
	test? ( dev-cpp/gmock )
	test? ( dev-cpp/gtest )
	valgrind? ( dev-util/valgrind )"


src_compile() {
	tc-export CXX CC OBJCOPY STRIP AR
	cros-debug-add-NDEBUG
	emake OUT=${S}/build \
		WITH_CHROME=$(use test && echo 1 || echo 0) \
		SPLITDEBUG=$(use splitdebug && echo 1) verity || \
		die "failed to make verity"
}

src_test() {
	# TODO(wad) add a verbose use flag to change the MODE=
	emake \
		OUT=${S}/build \
		VALGRIND=$(use valgrind && echo 1) \
		MODE=opt \
		SPLITDEBUG=0 \
		WITH_CHROME=1 \
		tests || die "unit tests (with ${GTEST_ARGS}) failed!"
}

src_install() {
	# TODO: copy splitdebug output somewhere
	into /
	dobin "${S}/build/verity"
}
