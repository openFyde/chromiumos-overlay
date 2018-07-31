# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools ltprune

DESCRIPTION="AVFS is a virtual filesystem that allows browsing of compressed files"
HOMEPAGE="https://sourceforge.net/projects/avf"
SRC_URI="mirror://sourceforge/avf/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="*"
IUSE="extfs static-libs +lzma"

RDEPEND=">=sys-fs/fuse-2.4:0
	sys-libs/zlib
	app-arch/bzip2
	lzma? ( app-arch/xz-utils )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

PATCHES=(
	# Work around a malformed zip file that doesn't set any file type on
	# a zip entry (crbug.com/173383).
	"${FILESDIR}"/${P}-zip-attr-fix.patch

	# Work around a zip file with extra bytes at the beginning of the file
	# (crbug.com/336690).
	"${FILESDIR}"/${P}-zip-handle-extra-bytes.patch

	# Add support to disable dynamic module loading since it is not used. All
	# the modules are compiled in statically.
	"${FILESDIR}"/${P}-disable-dynamic-modules.patch

	"${FILESDIR}"/${P}-use-posix-shell.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		--enable-fuse \
		--enable-library \
		--enable-shared \
		--disable-dynamic-modules \
		--with-system-zlib \
		--with-system-bzlib \
		$(use_enable static-libs static) \
		$(use_with lzma xz)
}

src_install() {
	default

	# remove cruft
	rm "${D}"/usr/bin/{davpass,ftppass} || die

	if use extfs; then
		# install extfs docs
		dosym /usr/$(get_libdir)/avfs/extfs/README /usr/share/doc/${PF}/README.extfs
	else
		# remove all the extfs modules
		rm -r "${D}"/usr/$(get_libdir)/avfs/extfs/ || die
	fi

	# install docs
	dodoc doc/{api-overview,background,FORMAT,INSTALL.*,README.avfs-fuse}

	docinto scripts
	dodoc scripts/{avfscoda*,*pass}

	prune_libtool_files
}

pkg_postinst() {
	if [[ -z ${REPLACING_VERSIONS} ]]; then
		einfo "This version of AVFS includes FUSE support. It is user-based."
		einfo "To execute:"
		einfo "1) as user, mkdir ~/.avfs"
		einfo "2) make sure fuse is either compiled into the kernel OR"
		einfo "   modprobe fuse or add to startup."
		einfo "3) run mountavfs"
		einfo "To unload daemon, type umountavfs"
		einfo
		einfo "READ the documentation! Enjoy :)"
	fi
}
