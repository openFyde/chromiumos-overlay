# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
CROS_WORKON_COMMIT="7b64e4ceb4d299dca61317c9379083bc77f3e83c"
CROS_WORKON_TREE="dc9366fb006e1db8f9f3ab40f0bd82a1f435cf05"
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
		-Dintrospection=disabled
		-Dman=disabled
		-Dbash_completion=false
	)
	meson_src_configure
}
