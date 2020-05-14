# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
CROS_WORKON_COMMIT="213eca340c157b96232242da15539e12efb2d5c9"
CROS_WORKON_TREE="902ceaea85c01fdd131e491b4615dafb28601761"
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
	aio? ( dev-libs/libaio:= )
	libiio_all? (
		avahi? ( net-dns/avahi )
	)
	!dev-libs/libiio"
DEPEND="${RDEPEND}"

src_configure() {
	# For test purposes, compile iiod and test tools, and allow connection over network.
	use libiio_all || mycmakeargs+=( -DWITH_IIOD=OFF -DWITH_TESTS=OFF -DWITH_NETWORK_BACKEND=OFF)

	# Remove udev rules to detect sensors on USB devices, USB and serial backends.
	mycmakeargs+=( -DINSTALL_UDEV_RULE=OFF -DWITH_USB_BACKEND=OFF -DWITH_SERIAL_BACKEND=OFF)

	cmake-utils_src_configure
	default
}
