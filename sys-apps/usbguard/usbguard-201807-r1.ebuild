# Copyright (c) 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

inherit autotools eutils

DESCRIPTION="The USBGuard software framework helps to protect your computer against rogue USB devices (a.k.a. BadUSB) by implementing basic whitelisting and blacklisting capabilities based on device attributes."
HOMEPAGE="https://usbguard.github.io/"
GIT_REV="1ed764f9f4740d6849b69612d62c23677efdae7f"
CATCH_REV="35f510545d55a831372d3113747bf1314ff4f2ef"
PEGTL_REV="4a41a7aec66deb99764246c5ce7d59f45489c175"
SRC_URI="https://github.com/USBGuard/usbguard/archive/${GIT_REV}.tar.gz -> ${P}.tar.gz
https://github.com/catchorg/Catch2/archive/${CATCH_REV}.tar.gz -> ${P}-catch.tar.gz
https://github.com/taocpp/PEGTL/archive/${PEGTL_REV}.tar.gz -> ${P}-pegtl.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="*"
IUSE=""

COMMON_DEPEND="
		dev-libs/dbus-glib
		dev-libs/libgcrypt
		dev-libs/protobuf
		sys-apps/dbus
		sys-cluster/libqb
		sys-libs/libcap-ng"

DEPEND="${COMMON_DEPEND}"

RDEPEND="${COMMON_DEPEND}"

S="${WORKDIR}/usbguard-${GIT_REV}/"

PATCHES=(
	"${FILESDIR}/daemon_conf.patch"
)

if [[ ${ARCH} = "amd64" ]]; then
	LIB_DIR=${EROOT}usr/lib64
else
	LIB_DIR=${EROOT}usr/lib
fi

src_prepare() {
	rm -rf "${S}/src/ThirdParty/Catch"
	mv "${WORKDIR}/Catch2-${CATCH_REV}" "${S}/src/ThirdParty/Catch"

	rm -rf "${S}/src/ThirdParty/PEGTL"
	mv "${WORKDIR}/PEGTL-${PEGTL_REV}" "${S}/src/ThirdParty/PEGTL"

	epatch "${PATCHES[@]}"
	eautoreconf
}

src_configure() {
	econf --without-polkit --without-dbus \
		--with-bundled-catch --with-bundled-pegtl --with-crypto-library=gcrypt \
		 CXXFLAGS="-fexceptions "
}

src_compile() {
	emake CXXFLAGS="-fexceptions "
}

src_install() {
	emake DESTDIR="${D}" install

	insinto /etc/usbguard
	doins usbguard-daemon.conf
	doins "${FILESDIR}/rules.conf"

	insinto /opt/google/usbguard
	newins "${FILESDIR}/usbguard-daemon-seccomp-${ARCH}.policy" usbguard-daemon-seccomp.policy

	insinto /etc/init
	doins "${FILESDIR}"/usbguard.conf
}
