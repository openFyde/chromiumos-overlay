# Copyright 1999-2020 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit cros-sanitizers user

DESCRIPTION="Qualcomm modem data service"
HOMEPAGE="https://source.codeaurora.org/quic/dataservices/modem-data-manager/log/?h=LC.UM.1.0"
#GIT_SHA1="b19614f4505db42c074bc32089fbdd48980f5f39"
SRC_URI="https://source.codeaurora.org/quic/dataservices/modem-data-manager/log/?h=LC.UM.1.0 -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="*"
IUSE="asan +seccomp"

DEPEND="net-libs/librmnetctl
	net-libs/libqrtr
"

RDEPEND="${DEPEND}"

S="${WORKDIR}/modem-data-manager"

PATCHES=(
	"${FILESDIR}"/0001-Fix-modem-configuration.patch # b/161835487
	"${FILESDIR}"/0002-Rename-NOTICE-to-LICENSE.patch
)

src_configure() {
	sanitizers-setup-env
}

src_install() {
	emake DESTDIR="${D}" prefix="${EPREFIX}/usr" install

	insinto /etc/init
	doins "${FILESDIR}/qc-netmgr.conf"
}
