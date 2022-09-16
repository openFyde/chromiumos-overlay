# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# Based on gentoo's modemmanager ebuild

EAPI=7
CROS_WORKON_PROJECT="chromiumos/third_party/modemmanager-next"
CROS_WORKON_EGIT_BRANCH="master"

inherit eutils autotools cros-sanitizers cros-workon flag-o-matic systemd udev user

DESCRIPTION="Modem and mobile broadband management libraries"
HOMEPAGE="https://www.freedesktop.org/wiki/Software/ModemManager/"
#SRC_URI not defined because we get our source locally

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~*"
IUSE="doc mbim systemd qmi qrtr"

RDEPEND=">=dev-libs/glib-2.36
	>=sys-apps/dbus-1.2
	dev-libs/dbus-glib
	net-dialup/ppp
	mbim? ( net-libs/libmbim )
	qmi? ( net-libs/libqmi )
	qrtr? ( net-libs/libqrtr-glib )
	!net-misc/modemmanager"

DEPEND="${RDEPEND}
	virtual/libgudev
	!net-misc/modemmanager-next-interfaces
	!net-misc/modemmanager"

BDEPEND="
	dev-util/gdbus-codegen
	dev-util/glib-utils
	dev-util/intltool
	>=dev-util/gtk-doc-am-1.13
	>=sys-devel/gettext-0.19.8"

DOCS="AUTHORS NEWS README"

src_prepare() {
	default

	# According to "Introspection Data Format" of the DBus specification,
	# revision 0.30 [1], "Only the root <node> element can omit the node
	# name, as it's known to be the object that was introspected. If the
	# root <node> does have a name attribute, it must be an absolute object
	# path. If child <node> have object paths, they must be relative."
	#
	# The introspection XMLs of ModemManager object interfaces specify
	# name="/" at their root <node>, which should be omitted instead as the
	# object paths aren't fixed.
	#
	# CL:294115 [2] removed the name="/" attribute from those root <node>s
	# in several ModemManager introspection XMLs in order to allow
	# chromeos-dbus-bindings to properly generate the DBus proxies for
	# ModemManager interfaces. Instead of modifying those introspection
	# XMLs directly in the modemmanager-next git repository, we patch them
	# (all org.freedesktop.ModemManager1.*.xml, but not
	# org.freedesktop.ModemManager1.xml) here instead, which helps minimize
	# the difference between the local modemmanager-next repository and the
	# upstream repository.
	#
	# TODO(benchan): Discuss with upstream ModemManager maintainers to see
	# if it makes sense to apply the changes to the upstream code instead.
	#
	# References:
	# [1] https://dbus.freedesktop.org/doc/dbus-specification.html#introspection-format
	# [2] http://crosreview.com/294115
	find introspection -type f -name 'org.freedesktop.ModemManager1.*.xml' \
		-exec sed -i 's/^<node name="\/"/<node/' {} +

	gtkdocize
	eautopoint
	eautoreconf
	intltoolize --force
}

src_configure() {
	# https://github.com/pkgconf/pkgconf/issues/205
	local -x PKG_CONFIG_FDO_SYSROOT_RULES=1

	sanitizers-setup-env
	append-flags -Xclang-only=-Wno-unneeded-internal-declaration
	append-flags -DWITH_NEWEST_QMI_COMMANDS
	# TODO(b/183029202): Remove this once we have support for IPv6 only network
	append-flags -DSUPPORT_MBIM_IPV6_WITH_IPV4_ROAMING
	append-flags -DMBIM_FIBOCOM_SAR_HACK
	econf \
		--with-html-dir="\${datadir}/doc/${PF}/html" \
		--enable-compile-warnings=yes \
		--enable-introspection=no \
		--with-powerd-suspend-resume \
		--disable-all-plugins   \
		--enable-plugin-fibocom \
		--enable-plugin-generic \
		--enable-plugin-huawei \
		--enable-plugin-intel \
		"$(use_enable {,gtk-}doc)" \
		"$(use_with mbim)" \
		"$(use_enable qrtr plugin-qcom-soc)" \
		"$(use_with qmi)"
}

src_test() {
	# TODO(b/180536539): Run unit tests for non-x86 platforms via qemu.
	if [[ "${ARCH}" == "x86" || "${ARCH}" == "amd64" ]] ; then
		# This is an ugly hack that happens to work, but should not be copied.
		PATH="${SYSROOT}/usr/bin:${PATH}" \
		LD_LIBRARY_PATH="${SYSROOT}/usr/$(get_libdir):${SYSROOT}/$(get_libdir)" \
		emake check
	fi
}

src_install() {
	default
	# Remove useless .la files
	find "${D}" -name '*.la' -delete

	# Remove the DBus service file generated by Makefile. This file directs DBus
	# to launch the ModemManager process when a DBus call for the ModemManager
	# service is received. We do not want this behaviour.
	find "${D}" -name 'org.freedesktop.ModemManager1.service' -delete

	# Seccomp policy file.
	insinto /usr/share/policy
	newins "${FILESDIR}/modemmanager-${ARCH}.policy" modemmanager.policy

	# Install init scripts.
	if use systemd; then
		systemd_dounit "${FILESDIR}/modemmanager.service"
		systemd_enable_service system-services.target modemmanager.service
	else
		insinto /etc/init
		doins "${FILESDIR}/modemmanager.conf"
	fi

	# Override the ModemManager DBus configuration file to constrain how
	# ModemManager exposes its DBus service on Chrome OS.
	insinto /etc/dbus-1/system.d
	doins "${FILESDIR}/org.freedesktop.ModemManager1.conf"

	# Install Chrome OS specific udev rules.
	udev_dorules "${FILESDIR}/52-mm-modem-permissions.rules"
	udev_dorules "${FILESDIR}/77-mm-huawei-configuration.rules"
	exeinto "$(get_udevdir)"
	doexe "${FILESDIR}/mm-huawei-configuration-switch.sh"
}

pkg_preinst() {
	# ModemManager is run under the 'modem' user and group on Chrome OS.
	enewuser "modem"
	enewgroup "modem"
}
