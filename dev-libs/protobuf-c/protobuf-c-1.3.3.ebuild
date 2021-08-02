# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools multilib-minimal

MY_PV="${PV/_/-}"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="Protocol Buffers implementation in C"
HOMEPAGE="https://github.com/protobuf-c/protobuf-c"
SRC_URI="https://github.com/${PN}/${PN}/releases/download/v${MY_PV}/${MY_P}.tar.gz"

LICENSE="BSD-2"
# Subslot == SONAME version
SLOT="0/1.0.0"
KEYWORDS="*"
IUSE="static-libs test"

RDEPEND=">=dev-libs/protobuf-3:0=[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}
	virtual/pkgconfig[${MULTILIB_USEDEP}]"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	default
	if ! use test; then
		eapply "${FILESDIR}"/${PN}-1.3.0-no-build-tests.patch
	fi

	eautoreconf
}

multilib_src_configure() {
	local myeconfargs=(
		$(use_enable static-libs static)
	)

	if tc-is-cross-compiler; then
		# In ChromeOS cross-compiled dev-libs/protobuf does not have libprotoc.
		# Disable protoc here too.
		myeconfargs+=( --disable-protoc )
	fi

	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}
