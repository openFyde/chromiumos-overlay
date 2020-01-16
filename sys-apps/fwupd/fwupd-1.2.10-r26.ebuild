# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CROS_WORKON_COMMIT="d5599d7c2db07a89ef83588c836587af5b0e60fe"
CROS_WORKON_TREE="b5117c382ba26776d953c8d58787bb71b4bd60c7"
CROS_WORKON_PROJECT="chromiumos/third_party/fwupd"

PYTHON_COMPAT=( python2_7 python3_{4,5,6,7} )

# Switched python-single-r1 with python-r1 to let python-wrapper use python3
# even when python2_7 is in use.
inherit cros-workon meson python-r1 user vala xdg-utils

DESCRIPTION="Aims to make updating firmware on Linux automatic, safe and reliable"
HOMEPAGE="https://fwupd.org"
#SRC_URI="https://github.com/hughsie/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1+"

SLOT="0"
KEYWORDS="*"
IUSE="colorhug daemon dell doc firmware-packager +gpg introspection +man nls nvme pkcs7 redfish synaptics systemd test thunderbolt uefi"
REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
	daemon? ( introspection )
	dell? ( uefi )
"

RDEPEND="
	app-arch/gcab
	app-arch/libarchive:=
	dev-db/sqlite
	>=dev-libs/glib-2.45.8:2
	dev-libs/json-glib
	dev-libs/libgpg-error
	dev-libs/libgudev:=
	>=dev-libs/libgusb-0.2.9[introspection?]
	>=dev-libs/libxmlb-0.1.7
	>=net-libs/libsoup-2.51.92:2.4[introspection?]
	virtual/libelf:0=
	colorhug? ( >=x11-misc/colord-1.2.12:0= )
	daemon? (
		>=sys-auth/consolekit-1.0.0
		>=sys-auth/polkit-0.103
	)
	dell? (
		sys-libs/efivar
		>=sys-libs/libsmbios-2.4.0
	)
	gpg? (
		app-crypt/gpgme
		dev-libs/libgpg-error
	)
	nvme? ( sys-libs/efivar )
	pkcs7? ( >=net-libs/gnutls-3.4.4.1:= )
	redfish? (
		sys-libs/efivar
	)
	systemd? ( >=sys-apps/systemd-211 )
	uefi? (
		${PYTHON_DEPS}
		dev-python/pillow[${PYTHON_USEDEP}]
		dev-python/pycairo[${PYTHON_USEDEP}]
		dev-python/pygobject:3[cairo,${PYTHON_USEDEP}]
		media-libs/fontconfig
		media-libs/freetype
		sys-boot/gnu-efi
		>=sys-libs/efivar-33
		x11-libs/cairo
	)
"
DEPEND="
	${RDEPEND}
	$(vala_depend)
	x11-libs/pango[introspection?]
	doc? ( dev-util/gtk-doc )
	man? ( app-text/docbook-sgml-utils )
	nvme? ( >=sys-kernel/linux-headers-4.4 )
	test? ( net-libs/gnutls[tools] )
"

BDEPEND="
	>=dev-util/meson-0.44.1
	virtual/pkgconfig
"

# required for fwupd daemon to run.
# NOT a build time dependency. The build system does not check for dbus.
PDEPEND="daemon? ( sys-apps/dbus )"

src_prepare() {
	default
	sed -e "s/'--create'/'--absolute-name', '--create'/" \
		-i data/tests/builder/meson.build || die
	sed -e "/^gcab/s/^/#/" -i meson.build || die
	if ! use nls ; then
		echo > po/LINGUAS || die
	fi
	vala_src_prepare
}

src_configure() {
	xdg_environment_reset
	local emesonargs=(
		--localstatedir "${EPREFIX}"/var
		-Dconsolekit="$(usex daemon true false)"
		-Ddaemon="$(usex daemon true false)"
		-Dfirmware-packager="$(usex firmware-packager true false)"
		-Dgpg="$(usex gpg true false)"
		-Dgtkdoc="$(usex doc true false)"
		-Dintrospection="$(usex introspection true false)"
		-Dman="$(usex man true false)"
		-Dpkcs7="$(usex pkcs7 true false)"
		-Dplugin_dell="$(usex dell true false)"
		-Dplugin_nvme="$(usex nvme true false)"
		-Dplugin_redfish="$(usex redfish true false)"
		-Dplugin_synaptics="$(usex synaptics true false)"
		-Dplugin_thunderbolt="$(usex thunderbolt true false)"
		-Dplugin_uefi="$(usex uefi true false)"
		-Dsystemd="$(usex systemd true false)"
		-Dtests="$(usex test true false)"
	)
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

	if use daemon ; then
		#doinitd "${FILESDIR}"/${PN}

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
	if use daemon ; then
		elog "In case you are using openrc as init system"
		elog "and you're upgrading from <fwupd-1.1.0, you"
		elog "need to start the fwupd daemon via the openrc"
		elog "init script that comes with this package."
	fi
}
