# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
CROS_WORKON_COMMIT="651dd2371301719b3d1482f8df1fabe1e014dc60"
CROS_WORKON_TREE="b758980c046c03ea765a0aaab7c9eb8666a04595"
CROS_WORKON_PROJECT="chromiumos/third_party/libqmi"

inherit meson cros-sanitizers cros-workon udev

DESCRIPTION="QMI modem protocol helper library"
HOMEPAGE="http://cgit.freedesktop.org/libqmi/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="*"
IUSE="-asan mbim qrtr"

RDEPEND=">=dev-libs/glib-2.36
	>=net-libs/libmbim-1.18.0
	net-libs/libqrtr-glib"

DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_configure() {
	sanitizers-setup-env

	local emesonargs=(
		--prefix='/usr'
		-Dqmi_username='modem'
		-Dlibexecdir='/usr/libexec'
		-Dudevdir='/lib/udev'
		-Dintrospection=false
		-Dman=false
		-Dbash_completion=false
	)
	meson_src_configure
}
