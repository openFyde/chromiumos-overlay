# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit gnome.org gnome2-utils meson-multilib xdg

DESCRIPTION="Network-related giomodules for glib"
HOMEPAGE="https://gitlab.gnome.org/GNOME/glib-networking"

LICENSE="LGPL-2.1+"
SLOT="0"
IUSE="+gnome +libproxy +ssl test"
RESTRICT="!test? ( test )"
KEYWORDS="*"

RDEPEND="
	>=dev-libs/glib-2.69.0:2[${MULTILIB_USEDEP}]
	libproxy? ( >=net-libs/libproxy-0.4.11-r1:=[${MULTILIB_USEDEP}] )
	>=net-libs/gnutls-3.7.2:=[${MULTILIB_USEDEP}]
	ssl? ( app-misc/ca-certificates )
	gnome? ( gnome-base/gsettings-desktop-schemas )
"
DEPEND="${RDEPEND}
	test? ( net-libs/gnutls[pkcs11] )
"
BDEPEND="
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
	test? ( sys-apps/dbus )
"

src_prepare() {
	default
	xdg_environment_reset

	if ! use test ; then
		# Don't build tests unconditionally
		# This is a hack to avoid needing gnutls[pkcs11] when USE=-test
		# It may become a real runtime dependency in future
		# Please check!
		# bug #777462
		sed -i "/^subdir('tests')/d" tls/meson.build || die
	fi
}

multilib_src_configure() {
	local emesonargs=(
		-Dgnutls=enabled
		-Dopenssl=disabled
		$(meson_feature libproxy)
		$(meson_feature gnome gnome_proxy)
		-Dinstalled_tests=false
		-Dstatic_modules=false
	)
	meson_src_configure
}

multilib_src_test() {
	dbus-run-session meson test -C "${BUILD_DIR}" || die 'tests failed'
}

pkg_postinst() {
	xdg_pkg_postinst

#	multilib_pkg_postinst() {
#		gnome2_giomodule_cache_update \
#			|| die "Update GIO modules cache failed (for ${ABI})"
#	}
#	multilib_foreach_abi multilib_pkg_postinst
}

pkg_postrm() {
	xdg_pkg_postrm

#	multilib_pkg_postrm() {
#		gnome2_giomodule_cache_update \
#			|| die "Update GIO modules cache failed (for ${ABI})"
#	}
#	multilib_foreach_abi multilib_pkg_postrm
}
