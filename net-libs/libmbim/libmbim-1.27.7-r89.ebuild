# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
CROS_WORKON_COMMIT="b0ff268ff01d2719f57adf0bb0e3aee809002d2d"
CROS_WORKON_TREE="f914dc61777f37d96b87db08ed86b9b3e3e2670c"
CROS_WORKON_PROJECT="chromiumos/third_party/libmbim"
CROS_WORKON_EGIT_BRANCH="master"

inherit meson cros-sanitizers cros-workon udev

DESCRIPTION="MBIM modem protocol helper library"
HOMEPAGE="http://cgit.freedesktop.org/libmbim/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="*"
IUSE="-asan doc static-libs"

RDEPEND=">=dev-libs/glib-2.36
	virtual/libgudev"

DEPEND="${RDEPEND}
	doc? ( dev-util/gtk-doc )
	virtual/pkgconfig"

src_configure() {
	sanitizers-setup-env

	local emesonargs=(
		--prefix='/usr'
		-Dmbim_username='modem'
		-Dlibexecdir='/usr/libexec'
		-Dudevdir='/lib/udev'
		-Dintrospection=false
		-Dman=false
		-Dbash_completion=false
	)
	meson_src_configure
}
