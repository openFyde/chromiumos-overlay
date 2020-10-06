# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CROS_WORKON_PROJECT="chromiumos/third_party/fwupd"
CROS_WORKON_EGIT_BRANCH="fwupd-1.4.5"

PYTHON_COMPAT=( python2_7 python3_{4,5,6,7} )

inherit cros-workon linux-info meson python-single-r1 user vala xdg

DESCRIPTION="Aims to make updating firmware on Linux automatic, safe and reliable"
HOMEPAGE="https://fwupd.org"
#SRC_URI="https://github.com/hughsie/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~*"
IUSE="agent amt consolekit dell gtk-doc elogind +minimal +gpg introspection +man nls nvme pkcs7 redfish synaptics systemd test thunderbolt uefi"
REQUIRED_USE="${PYTHON_REQUIRED_USE}
	^^ ( consolekit elogind minimal systemd )
	dell? ( uefi )
	minimal? ( !introspection )
"
RESTRICT="!test? ( test )"

BDEPEND="virtual/pkgconfig
	gtk-doc? ( dev-util/gtk-doc )
	introspection? ( dev-libs/gobject-introspection )
	man? (
		app-text/docbook-sgml-utils
		sys-apps/help2man
	)
	test? (
		thunderbolt? ( dev-util/umockdev )
		net-libs/gnutls[tools]
	)
"
RDEPEND=">=app-arch/gcab-1.0
	app-arch/libarchive:=
	dev-db/sqlite
	>=dev-libs/glib-2.45.8:2
	dev-libs/json-glib
	dev-libs/libgpg-error
	>=dev-libs/libgudev-232:=
	>=dev-libs/libgusb-0.3.5:=[introspection?]
	>=dev-libs/libjcat-0.1.0[gpg?,pkcs7?]
	>=dev-libs/libxmlb-0.1.13
	>=net-libs/libsoup-2.51.92:2.4[introspection?]
	virtual/libelf:0=
	virtual/udev
	consolekit? ( >=sys-auth/consolekit-1.0.0 )
	dell? (
		sys-libs/efivar
		>=sys-libs/libsmbios-2.4.0
	)
	elogind? ( sys-auth/elogind )
	!minimal? (
		>=sys-auth/polkit-0.103
	)
	nvme? ( sys-libs/efivar )
	redfish? ( sys-libs/efivar )
	systemd? ( >=sys-apps/systemd-211 )
	uefi? (
		app-crypt/tpm2-tss
		media-libs/fontconfig
		media-libs/freetype
		sys-boot/gnu-efi
		sys-boot/efibootmgr
		>=sys-libs/efivar-33
		x11-libs/cairo
	)
"
DEPEND="$(vala_depend)
	${PYTHON_DEPS}
	$(python_gen_cond_dep '
		dev-python/pillow[${PYTHON_USEDEP}]
		dev-python/pycairo[${PYTHON_USEDEP}]
		dev-python/pygobject:3[cairo,${PYTHON_USEDEP}]
	' ${PYTHON_COMPAT} )
	${RDEPEND}
"
# Block sci-chemistry/chemical-mime-data for bug #701900
RDEPEND+="
	!<sci-chemistry/chemical-mime-data-0.1.94-r4
	sys-apps/dbus
"

pkg_setup() {
	python-single-r1_pkg_setup
	if use nvme; then
		kernel_is -ge 4 4 || die "NVMe support requires kernel >= 4.4"
	fi
}

src_prepare() {
	default
	# c.f. https://github.com/fwupd/fwupd/issues/1414
	sed -e "/test('thunderbolt-self-test', e, env: test_env, timeout : 120)/d" \
		-i plugins/thunderbolt/meson.build || die
	sed -e "/^gcab/s/^/#/" -i meson.build || die
	if ! use nls ; then
		echo > po/LINGUAS || die
	fi
	vala_src_prepare
}

src_configure() {
	local emesonargs=(
		--localstatedir "${EPREFIX}"/var
		-Dbuild="$(usex minimal standalone all)"
		$(meson_use agent)
		$(meson_use amt plugin_amt)
		$(meson_use consolekit)
		$(meson_use dell plugin_dell)
		$(meson_use elogind)
		$(meson_use gtk-doc gtkdoc)
		$(meson_use introspection)
		$(meson_use man)
		$(meson_use nvme plugin_nvme)
		$(meson_use redfish plugin_redfish)
		$(meson_use synaptics plugin_synaptics)
		$(meson_use systemd)
		$(meson_use test tests)
		$(meson_use thunderbolt plugin_thunderbolt)
		$(meson_use uefi plugin_uefi)
		# Requires libflashrom which our sys-apps/flashrom
		# package does not provide
		-Dplugin_flashrom="false"
		# Dependencies are not available (yet?)
		-Dplugin_modem_manager="false"
		# Dependencies are not available (yet?)
		-Dplugin_tpm="false"
		-Dtpm="false"
	)
	export CACHE_DIRECTORY="${T}"
	meson_src_configure
}

src_install() {
	meson_src_install

	# Enable vendor-directory remote with local firmware
	sed 's/Enabled=false/Enabled=true/' -i "${ED}"/etc/${PN}/remotes.d/vendor-directory.conf || die

	insinto /etc/init
	# Install upstart script for activating firmware update on logout/shutdown.
	doins "${FILESDIR}"/fwupdtool-activate.conf
	# Install upstart script for reloading firmware metadata shown on chrome://system.
	doins "${FILESDIR}"/fwupdtool-getdevices.conf
	# Install upstart script for automatic firmware update on device plug-in.
	doins "${FILESDIR}"/fwupdtool-update.conf

	if ! use minimal ; then
		sed "s@%SEAT_MANAGER%@$(usex elogind elogind consolekit)@" \
			"${FILESDIR}"/${PN}-r1 \
			> "${T}"/${PN} || die
		doinitd "${T}"/${PN}

		if ! use systemd ; then
			# Don't timeout when fwupd is running (#673140)
			sed '/^IdleTimeout=/s@=[[:digit:]]\+@=0@' \
				-i "${ED}"/etc/${PN}/daemon.conf || die
		fi
	fi
}

pkg_preinst() {
	enewuser fwupd
	enewgroup fwupd
}

pkg_postinst() {
	xdg_pkg_postinst
	elog "In case you are using openrc as init system"
	elog "and you're upgrading from <fwupd-1.1.0, you"
	elog "need to start the fwupd daemon via the openrc"
	elog "init script that comes with this package."
}
