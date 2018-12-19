# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

GENTOO_DEPEND_ON_PERL=no

inherit perl-module systemd flag-o-matic autotools

if [[ "${PV}" == "9999" ]] ; then
	inherit bzr autotools
	EBZR_REPO_URI="http://bzr.linuxfoundation.org/openprinting/cups-filters"
else
	SRC_URI="http://www.openprinting.org/download/${PN}/${P}.tar.xz"
	KEYWORDS="*"
fi
DESCRIPTION="Cups filters"
HOMEPAGE="https://wiki.linuxfoundation.org/openprinting/cups-filters"

LICENSE="MIT GPL-2"
SLOT="0"
IUSE="dbus +foomatic ipp_autosetup jpeg ldap pclm pdf perl png +postscript static-libs test tiff zeroconf"

RDEPEND="
	>=app-text/poppler-0.32:=[cxx,jpeg?,lcms,tiff?,utils]
	>=app-text/qpdf-3.0.2:=
	dev-libs/glib:2
	media-libs/fontconfig
	media-libs/freetype:2
	media-libs/lcms:2
	>=net-print/cups-1.7.3
	!<=net-print/cups-1.5.9999
	sys-devel/bc
	sys-libs/zlib
	dbus? ( sys-apps/dbus )
	foomatic? ( !net-print/foomatic-filters )
	jpeg? ( virtual/jpeg:0 )
	ldap? ( net-nds/openldap )
	pclm? ( >=app-text/qpdf-7.0_beta1 )
	pdf? ( app-text/mupdf )
	perl? ( dev-lang/perl:= )
	png? ( media-libs/libpng:0= )
	postscript? ( >=app-text/ghostscript-gpl-9.09[cups] )
	tiff? ( media-libs/tiff:0 )
	zeroconf? ( net-dns/avahi[dbus] )
"
DEPEND="${RDEPEND}
	dev-util/gdbus-codegen
	test? ( media-fonts/dejavu )
"

PATCHES=(
	"${FILESDIR}/${PN}-1.17.8-pdftops-path.patch"
)

src_prepare() {
	default
	epatch "${PATCHES[@]}"
	eautoreconf

	# Bug #626800
	append-cxxflags -std=c++11
}

src_configure() {
	local myeconfargs=(
		--docdir="${EPREFIX}/usr/share/doc/${PF}"
		--enable-imagefilters
		--localstatedir="${EPREFIX}"/var
		--with-browseremoteprotocols=DNSSD,CUPS
		--with-cups-rundir="${EPREFIX}"/run/cups
		--with-fontdir="fonts/conf.avail"
		--with-pdftops=pdftops
		--with-rcdir=no
		--without-php
		$(use_enable dbus)
		$(use_enable foomatic)
		$(use_enable ipp_autosetup auto-setup-driverless)
		$(use_enable ldap)
		$(use_enable pclm)
		$(use_enable pdf mutool)
		$(use_enable postscript ghostscript)
		$(use_enable postscript ijs)
		$(use_enable static-libs static)
		$(use_enable zeroconf avahi)
		$(use_with jpeg)
		$(use_with png)
		$(use_with tiff)
	)
	econf "${myeconfargs[@]}"
}

src_compile() {
	default

	if use perl; then
		pushd "${S}/scripting/perl" > /dev/null
		perl-module_src_configure
		perl-module_src_compile
		popd > /dev/null
	fi
}

src_install() {
	default

	if use perl; then
		pushd "${S}/scripting/perl" > /dev/null
		perl-module_src_install
		perl_delete_localpod
		popd > /dev/null
	fi

	if use postscript; then
		# workaround: some printer drivers still require pstoraster and pstopxl, bug #383831
		dosym gstoraster /usr/libexec/cups/filter/pstoraster
		dosym gstopxl /usr/libexec/cups/filter/pstopxl
	fi

	find "${ED}" \( -name "*.a" -o -name "*.la" \) -delete || die

	cp "${FILESDIR}"/cups-browsed.init.d-r1 "${T}"/cups-browsed || die

	if ! use zeroconf ; then
		sed -i -e 's:need cupsd avahi-daemon:need cupsd:g' "${T}"/cups-browsed || die
		sed -i -e 's:cups\.service avahi-daemon\.service:cups.service:g' "${S}"/utils/cups-browsed.service || die
	fi

	doinitd "${T}"/cups-browsed
	systemd_dounit "${S}/utils/cups-browsed.service"
}

src_test() {
	emake check
}

pkg_postinst() {
	if ! use foomatic ; then
		ewarn "You are disabling the foomatic code in cups-filters. Please do that ONLY if absolutely."
		ewarn "necessary. net-print/foomatic-filters as replacement is deprecated and unmaintained."
	fi
}
