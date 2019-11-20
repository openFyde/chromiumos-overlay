# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"
CROS_WORKON_COMMIT="e5cc28a8bec257bc82e1936b075aab7b8c468c29"
CROS_WORKON_TREE="b38248b74b6e4811e5aedf97787d1cca17fda3d1"
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

src_prepare() {
	default
	sed -i "/^libdir/s:/lib:/$(get_libdir):" Makefile || die
}

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
