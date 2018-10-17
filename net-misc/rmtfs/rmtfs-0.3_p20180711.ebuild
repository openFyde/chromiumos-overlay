# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit cros-sanitizers

DESCRIPTION="QMI Remote File System Server"
HOMEPAGE="https://github.com/andersson/rmtfs"
GIT_SHA1="b3ea7fdf7b33bf1d9b225db41dcfb2041dd76ae0"
SRC_URI="https://github.com/andersson/rmtfs/archive/${GIT_SHA1}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="*"
IUSE="asan"

DEPEND="
	net-libs/libqrtr
	virtual/udev
"

RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}-${GIT_SHA1}"

PATCHES=(
	"${FILESDIR}/${PN}-configure-boot-directory.patch"
)

src_configure() {
	sanitizers-setup-env
}

src_compile() {
	emake RMTFS_DIR="/var/lib/rmtfs/boot"
}

src_install() {
	emake DESTDIR="${D}" prefix="${EPREFIX}/usr" install

	insinto /etc/init
	doins "${FILESDIR}/rmtfs.conf"
}
