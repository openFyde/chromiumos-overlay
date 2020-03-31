# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit cros-sanitizers user

DESCRIPTION="QMI Remote File System Server"
HOMEPAGE="https://github.com/andersson/rmtfs"
GIT_SHA1="9ef260ba6f550857dd87c3818ba3759343f45d2d"
SRC_URI="https://github.com/andersson/rmtfs/archive/${GIT_SHA1}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="*"
IUSE="asan +seccomp"

DEPEND="
	net-libs/libqrtr
	virtual/udev
"

RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}-${GIT_SHA1}"

src_configure() {
	sanitizers-setup-env
}

src_install() {
	emake DESTDIR="${D}" prefix="${EPREFIX}/usr" install

	insinto /etc/init
	doins "${FILESDIR}/rmtfs.conf"
	doins "${FILESDIR}/udev-trigger-rmtfs.conf"
	insinto /lib/udev/rules.d
	doins "${FILESDIR}/77-rmtfs.rules"

	# Install seccomp policy file.
	insinto /usr/share/policy
	use seccomp && newins "${FILESDIR}/rmtfs-seccomp-${ARCH}.policy" rmtfs-seccomp.policy
}

pkg_preinst() {
	enewgroup "rmtfs"
	enewuser "rmtfs"
}
