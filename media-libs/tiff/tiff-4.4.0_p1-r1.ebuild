# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# shellcheck disable=SC2034
QA_PKGCONFIG_VERSION="$(ver_cut 1-3)"

inherit autotools multilib-minimal libtool flag-o-matic

DESCRIPTION="Tag Image File Format (TIFF) library"
HOMEPAGE="http://libtiff.maptools.org"
MY_COMMIT="db1d2127862bb70df6b9d145c15ee592ee29bb7b"
MY_P="libtiff-${MY_COMMIT}"
SRC_URI="https://gitlab.com/libtiff/libtiff/-/archive/${MY_COMMIT}/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="libtiff"
SLOT="0"
if [[ ${PV} != *_rc* ]] ; then
	KEYWORDS="*"
fi
IUSE="cros_host +cxx jbig jpeg lzma static-libs test webp zlib zstd"
RESTRICT="!test? ( test )"

# bug #483132
REQUIRED_USE="test? ( jpeg )"

RDEPEND="jbig? ( >=media-libs/jbigkit-2.1:=[${MULTILIB_USEDEP}] )
	jpeg? ( media-libs/libjpeg-turbo:=[${MULTILIB_USEDEP}] )
	lzma? ( >=app-arch/xz-utils-5.0.5-r1[${MULTILIB_USEDEP}] )
	webp? ( media-libs/libwebp:=[${MULTILIB_USEDEP}] )
	zlib? ( >=sys-libs/zlib-1.2.8-r1[${MULTILIB_USEDEP}] )
	zstd? ( >=app-arch/zstd-1.3.7-r1:=[${MULTILIB_USEDEP}] )"
DEPEND="${RDEPEND}"

MULTILIB_WRAPPED_HEADERS=(
	/usr/include/tiffconf.h
)

src_prepare() {
	default
	# ChromeOS: generate configure script since we aren't using the pre-configured tar.gz
	eautoreconf
	elibtoolize
}

multilib_src_configure() {
	local myeconfargs=(
		--without-x
		--with-docdir="${EPREFIX}"/usr/share/doc/${PF}
		$(use_enable cxx)
		$(use_enable jbig)
		$(use_enable jpeg)
		$(use_enable lzma)
		$(use_enable static-libs static)
		$(use_enable webp)
		$(use_enable zlib)
		$(use_enable zstd)
	)

	# ChromeOS: install utilities to /usr/local unless installing to the SDK.
	if ! use cros_host ; then
		myeconfargs+=( --bindir="${EPREFIX}/usr/local/bin" )
	fi

	append-lfs-flags
	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"

	# Remove components (like tools) that are irrelevant for the multilib
	# build which we only want libraries for.
	# TODO: upstream options to disable these properly
	if ! multilib_is_native_abi ; then
		sed -i \
			-e 's/ tools//' \
			-e 's/ contrib//' \
			-e 's/ man//' \
			-e 's/ html//' \
			Makefile || die
	fi
}

multilib_src_test() {
	if ! multilib_is_native_abi ; then
		emake -C tools
	fi

	emake check
}

multilib_src_install_all() {
	find "${ED}" -type f -name '*.la' -delete || die
	# ChromeOS: COPYRIGHT doesn't exist in the top-of-tree version of libtiff.
	rm "${ED}"/usr/share/doc/${PF}/{README*,RELEASE-DATE,TODO,VERSION} || die
}
