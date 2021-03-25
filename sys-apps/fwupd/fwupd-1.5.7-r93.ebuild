# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CROS_WORKON_COMMIT="7ca66b415bad3383ca924f7aba4a60765d4cbcf2"
CROS_WORKON_TREE="f2c40c12ef98aabfc3c9709c2f8b6b5460b4391a"
CROS_WORKON_PROJECT="chromiumos/third_party/fwupd"
CROS_WORKON_EGIT_BRANCH="fwupd-1.5.7"

PYTHON_COMPAT=( python2_7 python3_{4,5,6,7} )

inherit cros-workon linux-info meson python-single-r1 udev user vala xdg

DESCRIPTION="Aims to make updating firmware on Linux automatic, safe and reliable"
HOMEPAGE="https://fwupd.org"
#SRC_URI="https://github.com/${PN}/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="*"
IUSE="agent amt archive +bluetooth dell +gnutls gtk-doc +gusb elogind flashrom_i2c +minimal +gpg introspection +man nls nvme pkcs7 policykit synaptics systemd test thunderbolt uefi"
REQUIRED_USE="${PYTHON_REQUIRED_USE}
	^^ ( elogind minimal systemd )
	dell? ( uefi )
	minimal? ( !introspection )
	uefi? ( gnutls )
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
	dev-libs/libgudev:=
	>=dev-libs/libjcat-0.1.0[gpg?,pkcs7?]
	>=dev-libs/libxmlb-0.1.13:=
	>=net-libs/libsoup-2.51.92:2.4[introspection?]
	net-misc/curl
	virtual/libelf:0=
	virtual/udev
	dell? ( >=sys-libs/libsmbios-2.4.0 )
	gnutls? ( net-libs/gnutls )
	gusb? ( >=dev-libs/libgusb-0.3.5[introspection?] )
	elogind? ( >=sys-auth/elogind-211 )
	policykit? ( >=sys-auth/polkit-0.103 )
	systemd? ( >=sys-apps/systemd-211 )
	uefi? (
		media-libs/fontconfig
		media-libs/freetype
		sys-boot/gnu-efi
		sys-boot/efibootmgr
		sys-fs/udisks
		sys-libs/efivar
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
	if use nvme ; then
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
		$(meson_use archive libarchive)
		$(meson_use bluetooth bluez)
		$(meson_use dell plugin_dell)
		$(meson_use elogind)
		$(meson_use gnutls)
		$(meson_use gtk-doc gtkdoc)
		$(meson_use gusb)
		$(meson_use gusb plugin_altos)
		$(meson_use man)
		$(meson_use nvme plugin_nvme)
		$(meson_use introspection)
		$(meson_use policykit polkit)
		$(meson_use synaptics plugin_synaptics_mst)
		$(meson_use synaptics plugin_synaptics_rmi)
		$(meson_use systemd)
		$(meson_use test tests)
		$(meson_use thunderbolt plugin_thunderbolt)
		$(meson_use uefi plugin_uefi_capsule)
		$(meson_use uefi plugin_uefi_pk)
		$(meson_use flashrom_i2c plugin_flashrom_i2c)
		-Dconsolekit="false"
		-Dcurl="true"
		# Requires libflashrom which our sys-apps/flashrom
		# package does not provide
		-Dplugin_flashrom="false"
		# Dependencies are not available (yet?)
		-Dplugin_modem_manager="false"
		-Dplugin_tpm="false"
		-Dtpm="false"
	)
	(use x86 || use amd64 ) || emesonargs+=( -Dplugin_msr="false" )
	export CACHE_DIRECTORY="${T}"
	meson_src_configure
}

src_install() {
	meson_src_install

	# Enable vendor-directory remote with local firmware
	sed 's/Enabled=false/Enabled=true/' -i "${ED}"/etc/${PN}/remotes.d/vendor-directory.conf || die

	# Install udev rules to fix user permissions.
	udev_dorules "${FILESDIR}"/90-fwupd.rules

	insinto /etc/init
	# Install upstart script for activating firmware update on logout/shutdown.
	doins "${FILESDIR}"/fwupdtool-activate.conf
	# Install upstart script for reloading firmware metadata shown on chrome://system.
	doins "${FILESDIR}"/fwupdtool-getdevices.conf
	# Install upstart script for automatic firmware update on device plug-in.
	doins "${FILESDIR}"/fwupdtool-update.conf

	exeinto /usr/share/cros/init
	doexe "${FILESDIR}"/fwupd-at-boot.sh

	if ! use minimal ; then
		sed "s@%SEAT_MANAGER%@elogind@" \
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
