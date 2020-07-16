# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson cros-sanitizers

DESCRIPTION="eSCL and WSD SANE backend"
HOMEPAGE="https://github.com/alexpevzner/sane-airscan"
LICENSE="GPL-2"
SLOT="0/${PVR}"
KEYWORDS="*"

COMMON_DEPEND="
	dev-libs/libxml2:=
	media-gfx/sane-backends:=
	media-libs/libjpeg-turbo:=
	media-libs/libpng:=
	net-dns/avahi:=
	net-libs/libsoup:=
"
DEPEND="${COMMON_DEPEND}"
RDEPEND="${COMMON_DEPEND}"

# SHA-1 or tag will both work.
GIT_REF="0.99.10"
SRC_URI="https://github.com/alexpevzner/sane-airscan/archive/${GIT_REF}.tar.gz -> ${PN}-${GIT_REF}.tar.gz"
S="${WORKDIR}/${PN}-${GIT_REF}"

src_configure() {
	sanitizers-setup-env
	meson_src_configure
}

src_install() {
	dobin "${BUILD_DIR}/airscan-discover"

	exeinto "/usr/$(get_libdir)/sane"
	doexe "${BUILD_DIR}/libsane-airscan.so.1"

	insinto "/etc/sane.d"
	newins "${FILESDIR}/airscan.conf" "airscan.conf"

	insinto "/etc/sane.d/dll.d"
	newins "${S}/dll.conf" "airscan.conf"
}
