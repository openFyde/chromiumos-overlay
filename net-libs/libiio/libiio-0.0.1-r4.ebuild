# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
CROS_WORKON_COMMIT="bca23460e8951af087404cae168fc53e4379744f"
CROS_WORKON_TREE="a59002b4db601a3564004e333ade818185126ed7"
CROS_WORKON_PROJECT="chromiumos/third_party/libiio"
CROS_WORKON_INCREMENTAL_BUILD=1

inherit cmake-utils cros-workon

DESCRIPTION="Library for interfacing with IIO devices"
HOMEPAGE="https://github.com/analogdevicesinc/libiio"

LICENSE="LGPL-2.1"
SLOT="0/${PV}"
KEYWORDS="*"

# By default, only libiio is installed.
# For testing, use USE=libiio_all to compile tests and iiod daemon.
IUSE="aio avahi libiio_all"

RDEPEND="dev-libs/libxml2:=
	virtual/libusb:1=
	aio? ( dev-libs/libaio:= )
	avahi? ( net-dns/avahi )
	!dev-libs/libiio"
DEPEND="${RDEPEND}"

src_configure() {
	use libiio_all || mycmakeargs+=( -DWITH_IIOD=OFF -DWITH_TESTS=OFF )

	# Remove udev rules to detect sensors on USB devices.
	mycmakeargs+=( -DINSTALL_UDEV_RULE=OFF )

	cros-workon_src_configure
	cmake-utils_src_configure
}
