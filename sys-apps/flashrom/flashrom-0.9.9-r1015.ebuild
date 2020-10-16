# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/flashrom/flashrom-0.9.4.ebuild,v 1.5 2011/09/20 16:03:21 nativemad Exp $

EAPI=7
CROS_WORKON_COMMIT="8cb48f7118ff9bf1e398d4d97db69e25710ff102"
CROS_WORKON_TREE="f5bebc473c8c8c91c0da024de3c2d164bbda019f"
CROS_WORKON_PROJECT="chromiumos/third_party/flashrom"

inherit cros-workon toolchain-funcs

DESCRIPTION="Utility for reading, writing, erasing and verifying flash ROM chips"
HOMEPAGE="http://flashrom.org/"
#SRC_URI="http://download.flashrom.org/releases/${P}.tar.bz2"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0/0"
KEYWORDS="*"
IUSE="+atahpt +bitbang_spi +buspirate_spi dediprog +drkaiser
+dummy +fdtmap +ft2232_spi +gfxnvidia +internal +linux_mtd +linux_spi
+lspcon_i2c_spi +nic3com +nicintel +nicintel_spi +nicnatsemi
+nicrealtek +ogp_spi +raiden_debug_spi +rayer_spi +realtek_mst_i2c_spi
+satasii +satamv +serprog static +wiki"

LIB_DEPEND="atahpt? ( sys-apps/pciutils[static-libs(+)] )
	dediprog? ( virtual/libusb:0[static-libs(+)] )
	drkaiser? ( sys-apps/pciutils[static-libs(+)] )
	fdtmap? ( sys-apps/dtc[static-libs(+)] )
	ft2232_spi? ( dev-embedded/libftdi[static-libs(+)] )
	gfxnvidia? ( sys-apps/pciutils[static-libs(+)] )
	internal? ( sys-apps/pciutils[static-libs(+)] )
	nic3com? ( sys-apps/pciutils[static-libs(+)] )
	nicintel? ( sys-apps/pciutils[static-libs(+)] )
	nicintel_spi? ( sys-apps/pciutils[static-libs(+)] )
	nicnatsemi? ( sys-apps/pciutils[static-libs(+)] )
	nicrealtek? ( sys-apps/pciutils[static-libs(+)] )
	raiden_debug_spi? ( virtual/libusb:1[static-libs(+)] )
	rayer_spi? ( sys-apps/pciutils[static-libs(+)] )
	satasii? ( sys-apps/pciutils[static-libs(+)] )
	satamv? ( sys-apps/pciutils[static-libs(+)] )
	ogp_spi? ( sys-apps/pciutils[static-libs(+)] )"
RDEPEND="!static? ( ${LIB_DEPEND//\[static-libs(+)]} )"
DEPEND="${RDEPEND}
	static? ( ${LIB_DEPEND} )"
RDEPEND+=" internal? ( sys-apps/dmidecode )"

BDEPEND="sys-apps/diffutils"

_flashrom_enable() {
	local c="CONFIG_${2:-$(echo $1 | tr [:lower:] [:upper:])}"
	args+=" $c=$(usex $1 yes no)"
}
flashrom_enable() {
	local u
	for u in "$@" ; do _flashrom_enable $u ; done
}

src_compile() {
	local progs=0
	local args=""

	# Programmer
	flashrom_enable \
		atahpt bitbang_spi buspirate_spi dediprog drkaiser fdtmap \
		ft2232_spi gfxnvidia linux_mtd linux_spi lspcon_i2c_spi \
		nic3com nicintel nicintel_spi nicnatsemi nicrealtek ogp_spi \
		raiden_debug_spi rayer_spi realtek_mst_i2c_spi satasii satamv \
		serprog internal dummy
	_flashrom_enable wiki PRINT_WIKI

	# You have to specify at least one programmer, and if you specify more than
	# one programmer you have to include either dummy or internal in the list.
	for prog in ${IUSE//[+-]} ; do
		case ${prog} in
			internal|dummy|wiki) continue ;;
		esac

		use ${prog} && : $(( progs++ ))
	done
	if [[ ${progs} -ne 1 ]] ; then
		if ! use internal && ! use dummy ; then
			ewarn "You have to specify at least one programmer, and if you specify"
			ewarn "more than one programmer, you have to enable either dummy or"
			ewarn "internal as well.  'internal' will be the default now."
			args+=" CONFIG_INTERNAL=yes"
		fi
	fi

	args+=" CONFIG_DEFAULT_PROGRAMMER=PROGRAMMER_INTERNAL"

	# Suppress -Wunused-function since we will see a lot of PCI-related
	# warnings on non-x86 platforms (PCI structs are pervasive in the code).
	append-flags "-Wall -Wno-unused-function"

	# WARNERROR=no, bug 347879
	# FIXME(dhendrix): Actually, we want -Werror for CrOS.
	tc-export AR CC PKG_CONFIG RANLIB
	# emake WARNERROR=no ${args}	# upstream gentoo

	_flashrom_enable static STATIC
	emake ${args}
}

src_install() {
	dosbin flashrom
	doman flashrom.8
	doheader libflashrom.h
	dodoc README.chromiumos Documentation/*.txt
}
