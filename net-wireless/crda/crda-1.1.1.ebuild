# Copyright 2008-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )
inherit toolchain-funcs multilib python-any-r1 udev

DESCRIPTION="Central Regulatory Domain Agent for wireless networks"
HOMEPAGE="https://wireless.kernel.org/en/developers/Regulatory"
SRC_URI="https://wireless.kernel.org/download/crda/${P}.tar.bz2"

LICENSE="ISC"
SLOT="0"
KEYWORDS="*"
IUSE=""

RDEPEND="dev-libs/libgcrypt
	dev-libs/libnl:0
	net-wireless/wireless-regdb"
DEPEND="${RDEPEND}
	dev-python/m2crypto"

src_prepare() {
	default

	##Make sure we install the rules where udev rules go...
	sed -i -e "/^UDEV_RULE_DIR/s:lib:$(get_libdir):" "${S}"/Makefile || \
	    die "Makefile sed failed"

	# install version that also handles "add" events
	cp -f "${FILESDIR}"/regulatory.rules "${S}"/udev || \
	    die "Failed to install new regulatory.rules"

	# Make sure we hit the correct pkg-config wrapper
	sed -i \
		-e "s:\<pkg-config\>:$(tc-getPKG_CONFIG):" \
		"${S}"/Makefile || die
}

src_compile() {
	#
	# NB: crda assumes regdbdump built for the target can run on
	#     the build host which doesn't work; use all_noverify as
	#     a WAR.  Using /usr/lib rather than $(get_libdir) since
	#     this is hard-coded (for good reason) in the ebuild for
	#     wireless-regdb.
	#
	emake CC="$(tc-getCC)" \
		PUBKEY_DIR="${SYSROOT}"/usr/lib/crda/pubkeys \
		all_noverify
}

src_install() {
	emake DESTDIR="${D}" UDEV_RULE_DIR=$(get_udevdir)/rules.d \
		install
}
