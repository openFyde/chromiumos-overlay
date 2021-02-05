# Copyright 2016 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cros-debug toolchain-funcs

DESCRIPTION="YUV library"
HOMEPAGE="https://chromium.googlesource.com/libyuv/libyuv"
GIT_SHA1="fc61dde1eb4b7807201fa20cd0a7d023363558b2"
SRC_URI="https://chromium.googlesource.com/libyuv/libyuv/+archive/${GIT_SHA1}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"

DEPEND="virtual/jpeg:0"

RDEPEND="${DEPEND}"
S="${WORKDIR}"

src_prepare() {
	rsync -a "${FILESDIR}"/. "${S}"/.
	eapply_user
}

src_compile() {
	tc-export CC CXX AR RANLIB LD NM PKG_CONFIG
	cros-debug-add-NDEBUG
	emake
}

src_install() {
	insinto /usr/include
	doins include/*.h
	insinto /usr/include/libyuv
	doins include/libyuv/*.h

	insinto /usr/$(get_libdir)
	dolib.a libyuv.pic.a

	sed -e "s:@LIB@:$(get_libdir):g" libyuv.pc.in > libyuv.pc || die
	insinto /usr/$(get_libdir)/pkgconfig
	doins libyuv.pc
}
