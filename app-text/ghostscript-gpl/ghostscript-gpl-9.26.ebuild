# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools cros-fuzzer cros-sanitizers flag-o-matic multilib \
				toolchain-funcs versionator


DESCRIPTION="Interpreter for the PostScript language and PDF"
HOMEPAGE="https://ghostscript.com/"

MY_P=${P/-gpl}
PVM=$(get_version_component_range 1-2)
PVM_S=$(replace_all_version_separators "" ${PVM})

MY_PATCHSET=1

SRC_URI="
	https://github.com/ArtifexSoftware/ghostpdl-downloads/releases/download/gs${PVM_S}/${MY_P}.tar.xz
	https://dev.gentoo.org/~dilfridge/distfiles/${P}-patchset-${MY_PATCHSET}.tar.xz
"

# Google has a commercial license for ghostscript when distributed with
# Chrome OS (not Chromium OS). So toggle the license to the required
# copyright when building for Chrome OS, and use the open source licensing
# text otherwise.
LICENSE="
	internal? ( LICENSE.artifex_commercial )
	!internal? ( AGPL-3 CPL-1.0 )
"
SLOT="0"
KEYWORDS="*"
IUSE="
	asan cups dbus fuzzer gtk idn internal linguas_de crosfonts static-libs
	tiff unicode X
"

LANGS="ja ko zh_CN zh_TW"
for X in ${LANGS} ; do
	IUSE="${IUSE} linguas_${X}"
done

COMMON_DEPEND="
	app-text/libpaper
	media-libs/fontconfig
	>=media-libs/freetype-2.4.9:2=
	>=media-libs/lcms-2.6:2
	>=media-libs/libpng-1.6.2:0=
	>=sys-libs/zlib-1.2.7
	virtual/jpeg:0
	cups? ( >=net-print/cups-1.3.8 )
	dbus? ( sys-apps/dbus )
	gtk? ( || ( x11-libs/gtk+:3 x11-libs/gtk+:2 ) )
	idn? ( net-dns/libidn )
	tiff? ( >=media-libs/tiff-4.0.1:0= )
	X? ( x11-libs/libXt x11-libs/libXext )
	!!media-libs/jbig2dec
"

DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig
"

RDEPEND="${COMMON_DEPEND}
	!crosfonts? ( >=app-text/poppler-data-0.4.7 )
	!crosfonts? ( >=media-fonts/urw-fonts-2.4.9 )
	linguas_ja? ( media-fonts/kochi-substitute )
	linguas_ko? ( media-fonts/baekmuk-fonts )
	linguas_zh_CN? ( media-fonts/arphicfonts )
	linguas_zh_TW? ( media-fonts/arphicfonts )
"

S="${WORKDIR}/${MY_P}"

PATCHES=(
	"${WORKDIR}/patches/"
	"${FILESDIR}/"
)

src_prepare() {
	# apply various patches, many borrowed from Fedora
	# http://pkgs.fedoraproject.org/cgit/ghostscript.git
	# in the same breath, apply patches specific to Chrome OS
	default

	# remove internal copies of various libraries
	rm -r "${S}"/cups/libs || die
	rm -r "${S}"/freetype || die
	rm -r "${S}"/lcms2mt || die
	rm -r "${S}"/libpng || die
	rm -r "${S}"/tiff || die
	rm -r "${S}"/zlib || die
	# remove internal CMaps (CMaps from poppler-data are used instead)
	rm -r "${S}"/Resource/CMap || die
	
	# Enable compilation of select contributed drivers,
	# but prune ones with incompatible or unclear licenses
	# (c.f. commit 0334118d6279640cb860f2f4a9af64b0fd008b49).
	rm -r "${S}"/contrib/epson740/ || die
	rm -r "${S}"/contrib/japanese || die
	rm -r "${S}"/contrib/md2k_md5k/ || die
	rm -r "${S}"/contrib/pscolor || die
	rm -r "${S}"/contrib/uniprint || die
	rm "${S}"/contrib/gdevgdi.c || die
	rm "${S}"/contrib/gdevln03.c || die
	rm "${S}"/contrib/gdevlx7.c || die
	rm "${S}"/contrib/gdevmd2k.c || die
	rm "${S}"/contrib/gdevop4w.c || die
	rm "${S}"/contrib/gdevxes.c || die

	if ! use gtk ; then
		sed -e "s:\$(GSSOX)::" \
			-e "s:.*\$(GSSOX_XENAME)$::" \
			-i "${S}"/base/unix-dll.mak || die "sed failed"
	fi

	if use crosfonts ; then
		rm -rf "${S}/Resource/Font"
		rm -rf "${S}/Resource/CIDFSubst"
	fi

	# Force the include dirs to a neutral location.
	sed -e "/^ZLIBDIR=/s:=.*:=${T}:" \
		-i "${S}"/configure.ac || die
	# Some files depend on zlib.h directly.  Redirect them. #573248
	# Also make sure to not define OPJ_STATIC to avoid linker errors due to
	# hidden symbols (https://bugs.freebsd.org/bugzilla/show_bug.cgi?id=203327#c1)
	sed -e '/^zlib_h/s:=.*:=:' \
		-e 's|-DOPJ_STATIC ||' \
		-i "${S}"/base/lib.mak || die

	# search path fix
	# put LDFLAGS after BINDIR, bug #383447
	sed -e "s:\$\(gsdatadir\)/lib:@datarootdir@/ghostscript/${PVM}/$(get_libdir):" \
		-e "s:exdir=.*:exdir=@datarootdir@/doc/${PF}/examples:" \
		-e "s:docdir=.*:docdir=@datarootdir@/doc/${PF}/html:" \
		-e "s:GS_DOCDIR=.*:GS_DOCDIR=@datarootdir@/doc/${PF}/html:" \
		-e 's:-L$(BINDIR):& $(LDFLAGS):g' \
		-i "${S}"/Makefile.in "${S}"/base/*.mak || die "sed failed"

	# remove incorrect symlink, bug 590384
	rm ijs/ltmain.sh || die
	eautoreconf

	cd "${S}"/ijs || die
	eautoreconf
}

src_configure() {
	sanitizers-setup-env
	append-cflags -fno-sanitize=shift

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

	cd "${S}"/ijs || die
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
		dosym ../../../poppler/cMaps "/usr/share/ghostscript/${PVM}/Resource/CMap"
	fi

	if ! use static-libs; then
		find "${ED}" -name '*.la' -delete || die
	fi

	if ! use linguas_de; then
		rm -r "${ED}"/usr/share/man/de || die
	fi

	if use crosfonts; then
		cat "${FILESDIR}"/Fontmap.cros >> "${ED}"/usr/share/ghostscript/${PVM}/Resource/Init/Fontmap.GS
	fi
}
