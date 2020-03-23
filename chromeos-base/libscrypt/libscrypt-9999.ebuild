# Copyright (c) 2009 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5
CROS_WORKON_PROJECT="chromiumos/third_party/libscrypt"
CROS_WORKON_LOCALNAME="third_party/libscrypt"

inherit cros-sanitizers cros-workon autotools

DESCRIPTION="Scrypt key derivation library"
HOMEPAGE="http://www.tarsnap.com/scrypt.html"
SRC_URI=""

LICENSE="BSD"
SLOT="0"
KEYWORDS="~*"
IUSE="-asan static-libs"

RDEPEND="dev-libs/openssl:0="
DEPEND="${RDEPEND}"

src_prepare() {
	epatch function_visibility.patch
	epatch "${FILESDIR}"/function_visibility2.patch
	eautoreconf
}

src_configure() {
	sanitizers-setup-env
	econf $(use_enable static-libs static)
}

src_install() {
	emake install DESTDIR="${D}"

	insinto /usr/include/scrypt
	doins src/lib/scryptenc/scryptenc.h
	doins src/lib/crypto/crypto_scrypt.h
}
