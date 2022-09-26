# Copyright 2019-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic toolchain-funcs

if [[ ${PV} =~ [9]{4,} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/libbpf/libbpf.git"
else
	SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="*"
fi
S="${WORKDIR}/${P}/src"

DESCRIPTION="Stand-alone build of libbpf from the Linux kernel"
HOMEPAGE="https://github.com/libbpf/libbpf"

LICENSE="GPL-2 LGPL-2.1 BSD-2"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE="static-libs"

DEPEND="
	sys-kernel/linux-headers
	virtual/libelf
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/libbpf-9999-paths.patch
)

src_configure() {
	append-cflags -fPIC
	tc-export CC AR
	export LIBSUBDIR="$(get_libdir)" V=1
}

src_install() {
	emake \
		DESTDIR="${D}" \
		install install_uapi_headers

	if ! use static-libs; then
		find "${ED}" -name '*.a' -delete || die
	fi

	insinto /usr/$(get_libdir)/pkgconfig
	doins ${PN}.pc
}
