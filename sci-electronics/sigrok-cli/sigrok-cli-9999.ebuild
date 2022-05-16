# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-electronics/sigrok-cli/sigrok-cli-9999.ebuild,v 1.1 2014/06/14 06:22:26 vapier Exp $

EAPI="5"

CROS_WORKON_PROJECT="chromiumos/third_party/libsigrok-cli"
CROS_WORKON_EGIT_BRANCH="chromeos"

PYTHON_COMPAT=( python3_{6..9} )
inherit cros-workon eutils python-single-r1 autotools

SRC_URI=""
KEYWORDS="~*"

DESCRIPTION="Command-line client for the sigrok logic analyzer software"
HOMEPAGE="http://sigrok.org/wiki/Sigrok-cli"

LICENSE="GPL-3"
SLOT="0"
IUSE="+decode"
REQUIRED_USE="decode? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND=">=dev-libs/glib-2.28.0
	>=sci-libs/libsigrok-0.3.0
	decode? (
		>=sci-libs/libsigrokdecode-0.3.0
		${PYTHON_DEPS}
	)"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	[[ ${PV} == "9999" ]] && eautoreconf

	# This is fixed after the 0.5.0 release.
	sed -i \
		-e '/WITH_SRD=$enableval/s:=$enableval:=$withval:' \
		configure || die
}

src_configure() {
	econf $(use_with decode libsigrokdecode)
}
