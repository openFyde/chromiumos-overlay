# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="ippsample print testing utility"
HOMEPAGE="https://github.com/istopwg/ippsample/blob/master/README.md"

LICENSE="Apache-2.0"

GIT_SHA1="ecfd14a4b6198a360e2b2ff48acc95ddde501019"
SRC_URI="https://github.com/istopwg/ippsample/archive/${GIT_SHA1}.zip -> ${P}.zip"

SLOT="0"
IUSE="+ssl"
KEYWORDS="*"

CDEPEND="
	ssl? (
		>=dev-libs/libgcrypt-1.5.3:=
		>=net-libs/gnutls-3.6.14:=
	)
"

DEPEND="${CDEPEND}"

RDEPEND="${CDEPEND}"

PATCHES=(
	"${FILESDIR}/ippsample-1.0.0-do-not-force-local-BinDir-directory.patch"
	"${FILESDIR}/ippsample-1.0.0-use-PKG_CONFIG.patch"
)

S="${WORKDIR}/${PN}-${GIT_SHA1}"

src_configure() {
	tc-export PKG_CONFIG

	local myeconfargs=(
		--enable-gnutls \
		--includedir=/usr/local/include
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default

	# Install ippserver test prerequisites
	insinto /usr/local/share/ippsample
	doins -r "${S}"/test
}

src_test() {
	emake check
}
