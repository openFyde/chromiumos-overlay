# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
CROS_WORKON_COMMIT="bc3f48ebd4178827a5661721acd8977c3979f223"
CROS_WORKON_TREE="5d367c3c99d1458032d07aaa9ea3d86df5e7803f"
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
