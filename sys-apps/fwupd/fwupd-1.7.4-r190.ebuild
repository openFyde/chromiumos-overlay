# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CROS_WORKON_COMMIT="91eb23c96167039afb3cc7dfc7f5653de50dfbef"
CROS_WORKON_TREE="fef4b2dfe09d20c89a0ba88ea6637f4dd710c7db"
CROS_WORKON_PROJECT="chromiumos/third_party/fwupd"
CROS_WORKON_EGIT_BRANCH="fwupd-1.7.4"

PYTHON_COMPAT=( python2_7 python3_{6..9} )

inherit cros-workon linux-info meson python-single-r1 udev user vala xdg

DESCRIPTION="Aims to make updating firmware on Linux automatic, safe and reliable"
HOMEPAGE="https://fwupd.org"
#SRC_URI="https://github.com/${PN}/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="*"
IUSE="agent amt archive bash-completion bluetooth dell +dummy elogind fastboot flashrom +gnutls gtk-doc +gusb +gpg gpio introspection logitech lzma +man minimal modemmanager nls nvme pkcs7 policykit spi +sqlite synaptics systemd test thunderbolt uefi"
REQUIRED_USE="${PYTHON_REQUIRED_USE}
	dell? ( uefi )
	fastboot? ( gusb )
	logitech? ( gusb )
	minimal? ( !introspection )
	spi? ( lzma )
	synaptics? ( gnutls )
	uefi? ( gnutls )
"

BDEPEND="
	virtual/pkgconfig
	gtk-doc? ( dev-util/gtk-doc )
	bash-completion? ( >=app-shells/bash-completion-2.0 )
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
COMMON_DEPEND="
	>=app-arch/gcab-1.0
	app-arch/xz-utils
	>=dev-libs/glib-2.58:2
	dev-libs/json-glib
	dev-libs/libgudev:=
	>=dev-libs/libjcat-0.1.0[gpg?,pkcs7?]
	>=dev-libs/libxmlb-0.1.13:=[introspection?]
	>=net-libs/libsoup-2.51.92:2.4[introspection?]
	net-misc/curl
	archive? ( app-arch/libarchive:= )
	dell? ( >=sys-libs/libsmbios-2.4.0 )
	elogind? ( >=sys-auth/elogind-211 )
	flashrom? ( sys-apps/flashrom )
	gnutls? ( net-libs/gnutls )
	gusb? ( >=dev-libs/libgusb-0.3.5[introspection?] )
	logitech? ( dev-libs/protobuf-c:= )
	lzma? ( app-arch/xz-utils )
	modemmanager? ( net-misc/modemmanager[qmi] )
	policykit? ( >=sys-auth/polkit-0.103 )
	sqlite? ( dev-db/sqlite )
	systemd? ( >=sys-apps/systemd-211 )
	uefi? (
		sys-apps/fwupd-efi
		sys-boot/efibootmgr
		sys-fs/udisks
		sys-libs/efivar
	)
"
# Block sci-chemistry/chemical-mime-data for bug #701900
RDEPEND="
	!<sci-chemistry/chemical-mime-data-0.1.94-r4
	${COMMON_DEPEND}
	sys-apps/dbus
"

DEPEND="
	${COMMON_DEPEND}
	x11-libs/pango
	$(vala_depend)
	${PYTHON_DEPS}
	$(python_gen_cond_dep '
		dev-python/pygobject:3[cairo,${PYTHON_USEDEP}]
	' ${PYTHON_COMPAT} )
	${RDEPEND}
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

	sed -e '/platform-integrity/d' \
		-i plugins/meson.build || die #753521
	sed -e "/^gcab/s/^/#/" -i meson.build || die
	if ! use nls ; then
		echo > po/LINGUAS || die
	fi
	vala_src_prepare
}

src_configure() {
	local plugins=(
		$(meson_use amt plugin_amt)
		$(meson_use dell plugin_dell)
		$(meson_use fastboot plugin_fastboot)
		$(meson_use dummy plugin_dummy)
		$(meson_use flashrom plugin_flashrom)
		$(meson_use gpio plugin_gpio)
		$(meson_use gusb plugin_uf2)
		$(meson_use logitech plugin_logitech_bulkcontroller)
		$(meson_use modemmanager plugin_modem_manager)
		$(meson_use nvme plugin_nvme)
		$(meson_use spi plugin_intel_spi)
		$(meson_use synaptics plugin_synaptics_mst)
		$(meson_use synaptics plugin_synaptics_rmi)
		$(meson_use thunderbolt plugin_thunderbolt)
		$(meson_use uefi plugin_uefi_capsule)
		$(meson_use uefi plugin_uefi_capsule_splash)
		$(meson_use uefi plugin_uefi_pk)

		# Dependencies are not available (yet?)
		-Dplugin_tpm="false"
	)
	(use x86 || use amd64 ) || plugins+=( -Dplugin_msr="false" )

	local emesonargs=(
		--localstatedir "${EPREFIX}"/var
		-Dbuild="$(usex minimal standalone all)"
		-Dcompat_cli="$(usex agent true false)"
		-Dconsolekit="false"
		-Dcurl="true"
		-Ddocs="$(usex gtk-doc gtkdoc none)"
		-Defi_binary="false"
		-Dsupported_build="true"
		$(meson_use archive libarchive)
		$(meson_use bash-completion bash_completion)
		$(meson_use bluetooth bluez)
		$(meson_use elogind)
		$(meson_use gnutls)
		$(meson_use gusb)
		$(meson_use lzma)
		$(meson_use man)
		$(meson_use introspection)
		$(meson_use policykit polkit)
		$(meson_use sqlite)
		$(meson_use systemd)
		$(meson_use systemd offline)
		$(meson_use test tests)

		${plugins[@]}
	)
	use uefi && emesonargs+=( -Defi_os_dir="gentoo" )
	export CACHE_DIRECTORY="${T}"
	meson_src_configure
}

src_install() {
	meson_src_install

	# Disable lvfs remote
	sed 's/Enabled=true/Enabled=false/' -i "${ED}"/etc/${PN}/remotes.d/lvfs.conf || die

	# Enable vendor-directory remote with local firmware
	sed 's/Enabled=false/Enabled=true/' -i "${ED}"/etc/${PN}/remotes.d/vendor-directory.conf || die

	# Install udev rules to fix user permissions.
	udev_dorules "${FILESDIR}"/90-fwupd.rules

	# Change D-BUS owner for org.freedesktop.fwupd
	sed 's/root/fwupd/' -i "${ED}"/usr/share/dbus-1/system.d/org.freedesktop.fwupd.conf || die

	# Install D-BUS service for org.freedesktop.fwupd to enable D-BUS activation
	insinto /usr/share/dbus-1/system-services
	doins "${FILESDIR}"/org.freedesktop.fwupd.service

	insinto /etc/init
	# Install upstart script for fwupd daemon.
	doins "${FILESDIR}"/fwupd.conf
	# Install upstart script for activating firmware update on logout/shutdown.
	doins "${FILESDIR}"/fwupdtool-activate.conf
	# Install upstart script for automatic firmware update on device plug-in.
	doins "${FILESDIR}"/fwupdtool-update.conf

	insinto /usr/lib/tmpfiles.d
	# Install tmpfiles script for generating the necessary directories
	doins "${FILESDIR}"/tmpfiles.d/fwupd.conf

	exeinto /usr/share/cros/init
	doexe "${FILESDIR}"/fwupd-at-boot.sh

	if ! use minimal ; then
		if ! use systemd ; then
			# Don't timeout when fwupd is running (#673140)
			sed '/^IdleTimeout=/s@=[[:digit:]]\+@=0@' \
				-i "${ED}"/etc/${PN}/daemon.conf || die
		fi
	fi
}

src_test() {
	meson_src_test
}

pkg_preinst() {
	enewuser fwupd
	enewgroup fwupd
}
