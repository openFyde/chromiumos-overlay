# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=7

inherit autotools eutils multilib-minimal

DESCRIPTION="A library to execute a function when a specific event occurs on a file descriptor"
HOMEPAGE="
	https://libevent.org/
	https://github.com/libevent/libevent/
"
SRC_URI="
	https://github.com/${PN}/${PN}/releases/download/release-${PV/_/-}-stable/${P/_/-}-stable.tar.gz -> ${P}.tar.gz
"

LICENSE="BSD"

SLOT="0/2.1-7"
KEYWORDS="*"
IUSE="debug +ssl static-libs test +threads"

DEPEND="
	ssl? (
		>=dev-libs/openssl-1.0.1h-r2:0=[${MULTILIB_USEDEP}]
	)
"
RDEPEND="
	${DEPEND}
	!<=dev-libs/9libs-1.0
"

MULTILIB_WRAPPED_HEADERS=(
	/usr/include/event2/event-config.h
)

S=${WORKDIR}/${P/_/-}-stable

src_prepare() {
	default
	eautoreconf

	# This patch is unique to Chromium OS until we can sort out:
	# https://github.com/libevent/libevent/pull/142
	# NB: must come after eautoreconf.
	eapply "${FILESDIR}"/${P}-libevent-shrink.patch
}

multilib_src_configure() {
	# fix out-of-source builds
	mkdir -p test || die

	cros_optimize_package_for_speed

	ECONF_SOURCE="${S}" \
	econf \
		--disable-samples \
		$(use_enable debug debug-mode) \
		$(use_enable debug malloc-replacement) \
		$(use_enable ssl openssl) \
		$(use_enable static-libs static) \
		$(use_enable test libevent-regress) \
		$(use_enable threads thread-support)
}

src_test() {
	# The test suite doesn't quite work (see bug #406801 for the latest
	# installment in a riveting series of reports).
	:
	# emake -C test check | tee "${T}"/tests
}

DOCS=( ChangeLog{,-1.4,-2.0} )

multilib_src_install_all() {
	einstalldocs
	find "${ED}" -name '*.la' -delete || die
}
