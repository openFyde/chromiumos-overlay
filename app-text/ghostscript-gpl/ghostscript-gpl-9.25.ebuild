# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools multilib versionator flag-o-matic toolchain-funcs

DESCRIPTION="Ghostscript is an interpreter for the PostScript language and for PDF"
HOMEPAGE="https://ghostscript.com/"

MY_P=${P/-gpl}
PVM=$(get_version_component_range 1-2)
PVM_S=$(replace_all_version_separators "" ${PVM})

MY_PATCHSET=1

SRC_URI="
	https://github.com/ArtifexSoftware/ghostpdl-downloads/releases/download/gs${PVM_S}/${MY_P}.tar.xz
	https://dev.gentoo.org/~dilfridge/distfiles/${P}-patchset-${MY_PATCHSET}.tar.xz
"

SLOT="0"
KEYWORDS="*"
IUSE="cups dbus gtk idn internal linguas_de crosfonts static-libs tiff unicode X"

# Google has a commercial license for ghostscript when distributed with Chrome OS (Not
# Chromium OS).  So toggle the license to the required copyright when building for Chrome OS,
# and use the open source licensing text otherwise.
LICENSE="
	internal? ( LICENSE.artifex_commercial )
	!internal? ( AGPL-3 CPL-1.0 )
"

COMMON_DEPEND="
	app-text/libpaper
	media-libs/fontconfig
	>=media-libs/freetype-2.4.9:2=
	media-libs/jbig2dec
	>=media-libs/lcms-2.6:2
	>=media-libs/libpng-1.6.2:0=
	>=sys-libs/zlib-1.2.7:=
	virtual/jpeg:0
	cups? ( >=net-print/cups-1.3.8 )
	dbus? ( sys-apps/dbus )
	gtk? ( || ( x11-libs/gtk+:3 x11-libs/gtk+:2 ) )
	idn? ( net-dns/libidn )
	tiff? ( >=media-libs/tiff-4.0.1:0= )
	X? ( x11-libs/libXt x11-libs/libXext )
"

DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig
"

RDEPEND="${COMMON_DEPEND}
	!crosfonts? ( >=app-text/poppler-data-0.4.5-r1 )
	!crosfonts? ( >=media-fonts/urw-fonts-2.4.9 )
	linguas_ja? ( media-fonts/kochi-substitute )
	linguas_ko? ( media-fonts/baekmuk-fonts )
	linguas_zh_CN? ( media-fonts/arphicfonts )
	linguas_zh_TW? ( media-fonts/arphicfonts )
	!!media-fonts/gnu-gs-fonts-std
	!!media-fonts/gnu-gs-fonts-other
	!<net-print/cups-filters-1.0.36-r2
"

S="${WORKDIR}/${MY_P}"

LANGS="ja ko zh_CN zh_TW"
for X in ${LANGS} ; do
	IUSE="${IUSE} linguas_${X}"
done

src_prepare() {
	default

	# remove internal copies of various libraries
	rm -rf "${S}"/cups/libs || die
	rm -rf "${S}"/expat || die
	rm -rf "${S}"/freetype || die
	rm -rf "${S}"/jbig2dec || die
	rm -rf "${S}"/jpeg{,xr} || die
	rm -rf "${S}"/lcms{,2} || die
	rm -rf "${S}"/libpng || die
	rm -rf "${S}"/tiff || die
	rm -rf "${S}"/zlib || die
	# remove internal CMaps (CMaps from poppler-data are used instead)
	rm -rf "${S}"/Resource/CMap || die

	# apply various patches, many borrowed from Fedora
	# http://pkgs.fedoraproject.org/cgit/ghostscript.git
	eapply "${FILESDIR}/"*.patch

	# remove files pruned in the patch ghostscript-*-prune-contrib-directory
	rm -rf "${S}"/contrib/epson740
	rm -rf "${S}"/contrib/gdevgdi.c
	rm -rf "${S}"/contrib/gdevln03.c
	rm -rf "${S}"/contrib/gdevlx7.c
	rm -rf "${S}"/contrib/gdevmd2k.c
	rm -rf "${S}"/contrib/gdevop4w.c
	rm -rf "${S}"/contrib/gdevxes.c
	rm -rf "${S}"/contrib/japanese
	rm -rf "${S}"/contrib/md2k_md5k
	rm -rf "${S}"/contrib/pscolor
	rm -rf "${S}"/contrib/uniprint

	if ! use gtk ; then
		sed -i -e "s:\$(GSSOX)::" \
			-e "s:.*\$(GSSOX_XENAME)$::" \
			"${S}"/base/unix-dll.mak || die "sed failed"
	fi

	if use crosfonts ; then
		rm -rf "${S}/Resource/Font"
		rm -rf "${S}/Resource/CIDFSubst"
	fi

	# Force the include dirs to a neutral location.
	sed -i \
		-e "/^ZLIBDIR=/s:=.*:=${T}:" \
		configure.ac || die
	# Some files depend on zlib.h directly.  Redirect them. #573248
	# Also make sure to not define OPJ_STATIC to avoid linker errors due to
	# hidden symbols (https://bugs.freebsd.org/bugzilla/show_bug.cgi?id=203327#c1)
	sed -i \
		-e '/^zlib_h/s:=.*:=:' \
		-e 's|-DOPJ_STATIC ||' \
		base/lib.mak || die

	# search path fix
	# put LDFLAGS after BINDIR, bug #383447
	sed -i -e "s:\$\(gsdatadir\)/lib:/usr/share/ghostscript/${PVM}/$(get_libdir):" \
		-e "s:exdir=.*:exdir=/usr/share/doc/${PF}/examples:" \
		-e "s:docdir=.*:docdir=/usr/share/doc/${PF}/html:" \
		-e "s:GS_DOCDIR=.*:GS_DOCDIR=/usr/share/doc/${PF}/html:" \
		-e 's:-L$(BINDIR):& $(LDFLAGS):g' \
		"${S}"/Makefile.in "${S}"/base/*.mak || die "sed failed"

	cd "${S}" || die
	eautoreconf

	cd "${S}/ijs" || die
	eautoreconf
}

src_configure() {
	local FONTPATH
	for path in \
		"${EPREFIX}"/usr/share/fonts/urw-fonts \
		"${EPREFIX}"/usr/share/fonts/Type1 \
		"${EPREFIX}"/usr/share/fonts \
		"${EPREFIX}"/usr/share/poppler/cMap/Adobe-CNS1 \
		"${EPREFIX}"/usr/share/poppler/cMap/Adobe-GB1 \
		"${EPREFIX}"/usr/share/poppler/cMap/Adobe-Japan1 \
		"${EPREFIX}"/usr/share/poppler/cMap/Adobe-Japan2 \
		"${EPREFIX}"/usr/share/poppler/cMap/Adobe-Korea1
	do
		FONTPATH="$FONTPATH${FONTPATH:+:}${EPREFIX}$path"
	done

	tc-export_build_env BUILD_CC

	# This list contains all ghostscript devices used by CUPS/PPD files.
	# It was built basing on an output from platform_PrinterPpds autotest.
	# See the readme.txt file in the autotest directory to learn how the list
	# was created.
	local devices=(
		ap3250 bj10e bj200 bjc600 bjc800 bjc880j bjccolor cdj500
		cdj550 cdnj500 cljet5c declj250 djet500 dnj650c epl2050 eplcolor
		eps9high eps9mid epson epsonc hl1250 ibmpro imagen jetp3852 laserjet
		lbp8 lips2p lips3 lips4 ljet2p ljet3 ljet4 ljetplus lp1800 lp1900
		lp2200 lp2400 lp2500 lp2563 lp3000c lp7500 lp7700 lp7900 lp8000
		lp8000c lp8100 lp8200c lp8300c lp8300f lp8400f lp8500c lp8600 lp8600f
		lp8700 lp8800c lp8900 lp9000b lp9000c lp9100 lp9200b lp9200c lp9300
		lp9400 lp9500c lp9600 lp9600s lp9800c lps4500 lps6500 lq850 lxm5700m
		m8510 necp6 oce9050 oki182 okiibm pcl3 picty180 pjxl300 pxlcolor
		pxlmono r4081 sj48 stcolor t4693d4 tek4696 uniprint
		# The "cups" driver is added if and only if we are building with CUPS.
		$(usev cups)
	)

	econf \
		CUPSCONFIG="${EROOT}/usr/bin/${CHOST}-cups-config" \
		CCAUX="${BUILD_CC}" \
		CFLAGSAUX="${BUILD_CFLAGS}" \
		LDFLAGSAUX="${BUILD_LDFLAGS}" \
		--enable-dynamic \
		--enable-freetype \
		--enable-fontconfig \
		--enable-openjpeg \
		--disable-compile-inits \
		--with-drivers="$(printf %s, "${devices[@]}")" \
		--with-fontpath="$FONTPATH" \
		--with-ijs \
		--with-jbig2dec \
		--with-libpaper \
		--without-luratech \
		$(use_enable cups) \
		$(use_enable dbus) \
		$(use_enable gtk) \
		$(use_with cups pdftoraster) \
		$(use_with idn libidn) \
		$(use_with tiff libtiff) \
		$(use_with tiff system-libtiff) \
		$(use_with X x)

	cd "${S}/ijs" || die
	econf \
		--enable-shared \
		$(use_enable static-libs static)
}

src_compile() {
	emake -j1 so all

	cd "${S}/ijs" || die
	emake
}

src_install() {
	emake DESTDIR="${D}" install-so install

	# move gsc to gs, bug #343447
	# gsc collides with gambit, bug #253064
	mv -f "${ED}"/usr/bin/{gsc,gs} || die

	cd "${S}/ijs" || die
	emake DESTDIR="${D}" install

	# rename the original cidfmap to cidfmap.GS
	mv "${ED}/usr/share/ghostscript/${PVM}/Resource/Init/cidfmap"{,.GS} || die

	# install our own cidfmap to handle CJK fonts
	insinto /usr/share/ghostscript/${PVM}/Resource/Init
	doins \
		"${WORKDIR}/fontmaps/CIDFnmap" \
		"${WORKDIR}/fontmaps/cidfmap"
	for X in ${LANGS} ; do
		if use linguas_${X} ; then
			doins "${WORKDIR}/fontmaps/cidfmap.${X/-/_}"
		fi
	done

	# install the CMaps from poppler-data properly, bug #409361
	if ! use crosfonts; then
		dosym /usr/share/poppler/cMaps /usr/share/ghostscript/${PVM}/Resource/CMap
	fi

	use static-libs || find "${ED}" -name '*.la' -delete

	if ! use linguas_de; then
		rm -r "${ED}"/usr/share/man/de || die
	fi

	if use crosfonts; then
		cat "${FILESDIR}"/Fontmap.cros >> "${ED}"/usr/share/ghostscript/${PVM}/Resource/Init/Fontmap.GS
	fi
}
