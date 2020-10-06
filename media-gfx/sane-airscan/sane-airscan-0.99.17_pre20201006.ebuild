# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson cros-fuzzer cros-sanitizers

DESCRIPTION="eSCL and WSD SANE backend"
HOMEPAGE="https://github.com/alexpevzner/sane-airscan"
LICENSE="GPL-2"
SLOT="0/${PVR}"
KEYWORDS="*"
IUSE="asan fuzzer"

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
GIT_REF="b89e2cbc8d92a0ce53ad7f276ce72203c732c031"
SRC_URI="https://github.com/alexpevzner/sane-airscan-unstable/archive/${GIT_REF}.tar.gz -> ${PN}-${GIT_REF}.tar.gz"
S="${WORKDIR}/${PN}-unstable-${GIT_REF}"

PATCHES=(
	"${FILESDIR}/sane-airscan-0.99.10-fuzzer.patch"
	"${FILESDIR}/sane-airscan-0.99.17-pointer-cast.patch"
)

src_prepare() {
	default_src_prepare
	cp "${FILESDIR}/airscan_xml_fuzzer.cc" "${S}" || die
}

src_configure() {
	sanitizers-setup-env || die
	fuzzer-setup-binary || die
	meson_src_configure
}

src_compile() {
	if use fuzzer; then
		meson_src_compile airscan_xml_fuzzer
	else
		meson_src_compile
	fi
}

src_install() {
	if ! use fuzzer; then
		dobin "${BUILD_DIR}/airscan-discover"

		exeinto "/usr/$(get_libdir)/sane"
		doexe "${BUILD_DIR}/libsane-airscan.so.1"

		insinto "/etc/sane.d"
		newins "${FILESDIR}/airscan.conf" "airscan.conf"

		insinto "/etc/sane.d/dll.d"
		newins "${S}/dll.conf" "airscan.conf"
	fi

	# Safe to call even if the fuzzer isn't built because this won't do
	# anything unless we have USE=fuzzer.
	fuzzer_install "${FILESDIR}/fuzzers.owners" \
		"${BUILD_DIR}/airscan_xml_fuzzer"

}
