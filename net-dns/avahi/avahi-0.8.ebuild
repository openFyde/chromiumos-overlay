# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

PYTHON_COMPAT=( python3_{7,8} )
PYTHON_REQ_USE="gdbm"
inherit autotools cros-fuzzer cros-sanitizers eutils flag-o-matic multilib multilib-minimal mono-env python-r1 systemd user

DESCRIPTION="System which facilitates service discovery on a local network"
HOMEPAGE="http://avahi.org/"
SRC_URI="https://github.com/lathiat/avahi/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="*"
IUSE="autoipd bookmarks dbus doc fuzzer gdbm gtk gtk2 howl-compat +introspection ipv6 kernel_linux mdnsresponder-compat mono nls python qt5 selinux systemd test"

REQUIRED_USE="
	python? ( dbus gdbm ${PYTHON_REQUIRED_USE} )
	mono? ( dbus )
	howl-compat? ( dbus )
	mdnsresponder-compat? ( dbus )
	systemd? ( dbus )
"

RESTRICT="!test? ( test )"

DEPEND="
	dev-libs/libdaemon
	dev-libs/libevent:=[${MULTILIB_USEDEP}]
	dev-libs/expat
	dev-libs/glib:2[${MULTILIB_USEDEP}]
	gdbm? ( sys-libs/gdbm:=[${MULTILIB_USEDEP}] )
	qt5? ( dev-qt/qtcore:5 )
	gtk2? ( x11-libs/gtk+:2[${MULTILIB_USEDEP}] )
	gtk?  ( x11-libs/gtk+:3[${MULTILIB_USEDEP}] )
	dbus? ( sys-apps/dbus[${MULTILIB_USEDEP}] )
	kernel_linux? ( sys-libs/libcap )
	introspection? ( dev-libs/gobject-introspection:= )
	mono? (
		dev-lang/mono
		gtk2? ( dev-dotnet/gtk-sharp:2 )
	)
	python? (
		${PYTHON_DEPS}
		dbus? ( dev-python/dbus-python[${PYTHON_USEDEP}] )
		introspection? ( dev-python/pygobject:3[${PYTHON_USEDEP}] )
	)
	bookmarks? (
		${PYTHON_DEPS}
		>=dev-python/twisted-16.0.0[${PYTHON_USEDEP}]
	)
"
RDEPEND="
	${DEPEND}
	selinux? ( sec-policy/selinux-avahi )
"
BDEPEND="
	dev-util/glib-utils
	doc? ( app-doc/doxygen )
	app-doc/xmltoman
	dev-util/intltool
	virtual/pkgconfig
"

MULTILIB_WRAPPED_HEADERS=( /usr/include/avahi-qt5/qt-watch.h )

PATCHES=(
	"${FILESDIR}/${PN}-0.7-fuzzer.patch"
	"${FILESDIR}/${PN}-0.7-log-address-resolution.patch"
	"${FILESDIR}/${PN}-0.7-cache-host-name-record-A.patch"
	"${FILESDIR}/${PN}-0.8-fix-timeouts-leak.patch"
	"${FILESDIR}/${PN}-0.8-avoid-infinite-loop-by-handling-HUP-event.patch"
	"${FILESDIR}/${PN}-0.8-fix-NULL-pointer-crashes-badly-formatted-hostnames.patch"
	"${FILESDIR}/${PN}-0.8-coverity-use-after-free.patch"
	"${FILESDIR}/${PN}-0.8-increase-hashmap-buckets.patch"
	"${FILESDIR}/${PN}-0.8-inexpensive-checks-first.patch"
	"${FILESDIR}/${PN}-0.8-onepass-domain-equal.patch"
)

pkg_preinst() {
	enewgroup netdev
	enewgroup avahi
	enewuser avahi -1 -1 -1 avahi
	if use autoipd; then
		enewgroup avahi-autoipd
		enewuser avahi-autoipd -1 -1 -1 avahi-autoipd
	fi
}

pkg_setup() {
	use mono && mono-env_pkg_setup
	use python || use bookmarks && python_setup
}

src_prepare() {
	default

	if ! use ipv6; then
		sed -i \
			-e "s/use-ipv6=yes/use-ipv6=no/" \
			avahi-daemon/avahi-daemon.conf || die
	fi

	sed -i \
		-e "s:\\.\\./\\.\\./\\.\\./doc/avahi-docs/html/:../../../doc/${PF}/html/:" \
		doxygen_to_devhelp.xsl || die

	eautoreconf

	# bundled manpages
	multilib_copy_sources
}

src_configure() {
	# those steps should be done once-per-ebuild rather than per-ABI
	cros_optimize_package_for_speed
	sanitizers-setup-env
	use sh && replace-flags -O? -O0
	use python && python_setup
	multilib-minimal_src_configure
}

multilib_src_configure() {
	local myconf=(
		--disable-monodoc
		--disable-python-dbus
		--disable-qt3
		--disable-qt4
		--disable-static
		--enable-manpages
		--enable-glib
		--enable-gobject
		--enable-xmltoman
		--localstatedir="${EPREFIX}/var"
		--with-distro=gentoo
		--with-systemdsystemunitdir="$(systemd_get_systemunitdir)"
		$(use_enable dbus)
		$(use_enable gdbm)
		$(use_enable gtk2 gtk)
		$(use_enable gtk  gtk3)
		$(use_enable howl-compat compat-howl)
		$(use_enable mdnsresponder-compat compat-libdns_sd)
		$(use_enable nls)
		$(multilib_native_use_enable autoipd)
		$(multilib_native_use_enable doc doxygen-doc)
		$(multilib_native_use_enable introspection)
		$(multilib_native_use_enable mono)
		$(multilib_native_use_enable python)
		$(multilib_native_use_enable test tests)
	)

	if use python; then
		myconf+=(
			$(multilib_native_use_enable dbus python-dbus)
			$(multilib_native_use_enable introspection pygobject)
		)
	fi

	if use mono; then
		myconf+=( $(multilib_native_use_enable doc monodoc) )
	fi

	if ! multilib_is_native_abi; then
		myconf+=(
			# used by daemons only
			--disable-libdaemon
			--with-xml=none
		)
	fi

	if use fuzzer ; then
		myconf+=(--enable-fuzzer)
	fi

	myconf+=( $(multilib_native_use_enable qt5) )

	econf "${myconf[@]}"
}

multilib_src_compile() {
	emake

	multilib_is_native_abi && use doc && emake avahi.devhelp
}

multilib_src_install() {
	emake install DESTDIR="${D}"
	use bookmarks && use python && use dbus && use gtk2 || \
		rm -f "${ED}"/usr/bin/avahi-bookmarks

	# https://github.com/lathiat/avahi/issues/28
	use howl-compat && dosym avahi-compat-howl.pc /usr/$(get_libdir)/pkgconfig/howl.pc
	use mdnsresponder-compat && dosym avahi-compat-libdns_sd/dns_sd.h /usr/include/dns_sd.h

	if multilib_is_native_abi && use doc; then
		docinto html
		dodoc -r doxygen/html/.
		insinto /usr/share/devhelp/books/avahi
		doins avahi.devhelp
	fi

	# fuzzer_component_id is unknown/unlisted
	fuzzer_install "${FILESDIR}/OWNERS" "examples/.libs/recv_fuzzer"

	# The build system creates an empty "/run" directory, so we clean it up here
	rmdir "${ED}"/run || die
}

multilib_src_install_all() {
	if use autoipd; then
		insinto /$(get_libdir)/rcscripts/net
		doins "${FILESDIR}"/autoipd.sh

		insinto /$(get_libdir)/netifrc/net
		newins "${FILESDIR}"/autoipd-openrc.sh autoipd.sh
	fi

	dodoc docs/{AUTHORS,NEWS,README,TODO}

	find "${ED}" -name '*.la' -type f -delete || die
}

pkg_postinst() {
	if use autoipd; then
		elog
		elog "To use avahi-autoipd to configure your interfaces with IPv4LL (RFC3927)"
		elog "addresses, just set config_<interface>=( autoipd ) in /etc/conf.d/net!"
		elog
	fi

	systemd_reenable avahi-daemon.service
}
