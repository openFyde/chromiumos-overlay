# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CROS_WORKON_COMMIT="011a2df0e717ba6857e0b4b86705d531a8fd3cbf"
CROS_WORKON_TREE="995f380331f33d9e9b53d97d02c992d0fc03900e"
CROS_WORKON_PROJECT="chromiumos/third_party/fwupd"

PYTHON_COMPAT=( python2_7 python3_4 python3_5 python3_6 )

inherit cros-workon meson python-single-r1 vala xdg-utils

DESCRIPTION="Aims to make updating firmware on Linux automatic, safe and reliable"
HOMEPAGE="https://fwupd.org"
#SRC_URI="https://github.com/hughsie/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"

SLOT="0"
KEYWORDS="*"
IUSE="colorhug consolekit dell doc gpg +man pkcs7 systemd test uefi uefi_labels"
REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
"
# tbroch did this
#	${PYTHON_DEPS}
#	dev-python/pillow[${PYTHON_USEDEP}]
#	dev-python/pycairo[${PYTHON_USEDEP}]
#	dev-python/pygobject:3[cairo,${PYTHON_USEDEP}]
RDEPEND="
	app-arch/libarchive:=
	dev-db/sqlite
	>=dev-libs/appstream-glib-0.6.13:=[introspection]
	>=dev-libs/glib-2.45.8:2
	dev-libs/libgpg-error
	dev-libs/libgudev:=
	>=dev-libs/libgusb-0.2.9[introspection]
	>=net-libs/libsoup-2.51.92:2.4[introspection]
	>=sys-auth/polkit-0.103
	virtual/libelf:0=
	colorhug? ( >=x11-misc/colord-1.2.12:0= )
	dell? (
		sys-libs/efivar
		>=sys-libs/libsmbios-2.3.3
	)
	gpg? (
		app-crypt/gpgme
		dev-libs/libgpg-error
	)
	pkcs7? ( net-libs/gnutls:= )
	systemd? ( >=sys-apps/systemd-231 )
	consolekit? ( >=sys-auth/consolekit-1.0.0 )
	uefi? ( >=sys-apps/fwupdate-5 )
	uefi_labels? (
		x11-libs/pango
		x11-libs/cairo
		media-libs/freetype
		media-libs/fontconfig
		media-fonts/dejavu
		media-fonts/source-han-sans
	)
"
DEPEND="
	${RDEPEND}
	app-arch/gcab
	app-arch/libarchive
	virtual/pkgconfig
	$(vala_depend)
	doc? ( dev-util/gtk-doc )
	man? ( app-text/docbook-sgml-utils )
	test? ( net-libs/gnutls[tools] )
"

REQUIRED_USE="dell? ( uefi )"

src_prepare() {
	default
	sed -i -e "s/'--create'/'--absolute-name', '--create'/" data/tests/builder/meson.build || die
	vala_src_prepare
}

src_configure() {
	xdg_environment_reset
	local emesonargs=(
		-Dconsolekit="$(usex consolekit true false)"
		-Dgpg="$(usex gpg true false)"
		-Dgtkdoc="$(usex doc true false)"
		-Dman="$(usex man true false)"
		-Dpkcs7="$(usex pkcs7 true false)"
		-Dplugin_colorhug="$(usex colorhug true false)"
		-Dplugin_dell="$(usex dell true false)"
		-Dplugin_synaptics="$(usex dell true false)"
		# requires libtbtfwu which is not packaged (yet?)
		-Dplugin_thunderbolt=false
		-Dplugin_uefi="$(usex uefi true false)"
		-Dplugin_uefi-labels="$(usex uefi_labels true false)"
		-Dsystemd="$(usex systemd true false)"
		-Dtests="$(usex test true false)"
	)
	meson_src_configure
}
