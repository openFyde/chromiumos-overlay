# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"
CROS_WORKON_COMMIT="1604a9567beda30fb5d8fd532c0ec8366da8fbbb"
CROS_WORKON_TREE="f01755e90641a41b7ce3ddb92a2bd3a5216124f2"
CROS_WORKON_PROJECT="chromiumos/third_party/libqrtr"

inherit autotools cros-sanitizers cros-workon user

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
	sanitizers-setup-env
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
