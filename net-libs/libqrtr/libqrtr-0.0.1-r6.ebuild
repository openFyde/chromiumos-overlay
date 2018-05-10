# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"
CROS_WORKON_COMMIT="238c066146896e9caa9e724ce43080d07ac4fb3f"
CROS_WORKON_TREE="bfaf3c190684e33423296a29d6b37fc69043c3e4"
CROS_WORKON_PROJECT="chromiumos/third_party/libqrtr"

inherit autotools cros-workon user

DESCRIPTION="QRTR userspace helper library"
HOMEPAGE="https://github.com/andersson/qrtr"

LICENSE="BSD"
SLOT="0"
KEYWORDS="*"
IUSE="-asan"

DEPEND="
	sys-kernel/linux-headers
	virtual/pkgconfig
"

src_configure() {
	asan-setup-env
}

src_install() {
	emake DESTDIR="${D}" prefix="${EPREFIX}/usr" install

	insinto /etc/init
	doins "${FILESDIR}/qrtr-ns.conf"

	insinto /usr/share/policy
	newins "${FILESDIR}/qrtr-ns-seccomp-${ARCH}.policy" qrtr-ns-seccomp.policy
}

src_test() {
	# TODO(ejcaruso): upstream some tests for this thing
	:
}

pkg_preinst() {
	enewuser "qrtr"
	enewgroup "qrtr"
}
