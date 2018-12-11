# Copyright 2019 The Chromium OS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

DESCRIPTION="DIAG channel diagnostics communication tool"
HOMEPAGE="https://github.com/andersson/diag"
GIT_SHA1="bf8035f68b0748d1380977aafc4349331b74cbda"
SRC_URI="https://github.com/andersson/diag/archive/${GIT_SHA1}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="*"

DEPEND="
	net-libs/libqrtr:=
	virtual/udev:=
"

RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}-${GIT_SHA1}"

src_compile() {
	emake HAVE_LIBUDEV=1 HAVE_LIBQRTR=1
}

src_install() {
	emake DESTDIR="${D}" prefix="${EPREFIX}/usr" install
}
