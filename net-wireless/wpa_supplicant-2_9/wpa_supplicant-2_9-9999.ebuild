# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_PROJECT="chromiumos/third_party/hostap"
CROS_WORKON_LOCALNAME="../third_party/wpa_supplicant-2.9"
CROS_WORKON_EGIT_BRANCH="wpa_supplicant-2.9"

inherit cros-sanitizers cros-workon eutils flag-o-matic qmake-utils systemd toolchain-funcs user

DESCRIPTION="IEEE 802.1X/WPA supplicant for secure wireless transfers"
HOMEPAGE="https://w1.fi/wpa_supplicant/"
LICENSE="|| ( GPL-2 BSD )"

SLOT="0"
KEYWORDS="~*"
IUSE="ap bindist dbus debug eap-sim +hs2-0 libressl mbo p2p ps3 qt5 readline +seccomp selinux smartcard systemd +tdls uncommon-eap-types wifi_hostap_test +wnm wps kernel_linux kernel_FreeBSD wimax"

CDEPEND="
	chromeos-base/minijail
	dbus? ( sys-apps/dbus )
	kernel_linux? (
		dev-libs/libnl:3
		net-wireless/crda
	)
	!kernel_linux? ( net-libs/libpcap )
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtsvg:5
		dev-qt/qtwidgets:5
	)
	readline? (
		sys-libs/ncurses:0
		sys-libs/readline:0
	)
	!libressl? ( dev-libs/openssl:0=[bindist=] )
	libressl? ( dev-libs/libressl:0= )
	smartcard? ( dev-libs/engine_pkcs11 )
"
DEPEND="${CDEPEND}
	virtual/pkgconfig
"
RDEPEND="${CDEPEND}
	!net-wireless/wpa_supplicant
	!net-wireless/wpa_supplicant-2_8
	selinux? ( sec-policy/selinux-networkmanager )
"

# S="${WORKDIR}/${P}/${PN}"
src_unpack() {
	cros-workon_src_unpack
	S+="/wpa_supplicant"
}

Kconfig_style_config() {
		#param 1 is CONFIG_* item
		#param 2 is what to set it = to, defaulting in y
		CONFIG_PARAM="${CONFIG_HEADER:-CONFIG_}$1"
		setting="${2:-y}"

		if [ ! $setting = n ]; then
			#first remove any leading "# " if $2 is not n
			sed -i "/^# *$CONFIG_PARAM=/s/^# *//" .config || echo "Kconfig_style_config error uncommenting $CONFIG_PARAM"
			#set item = $setting (defaulting to y)
			sed -i "/^$CONFIG_PARAM\>/s/=.*/=$setting/" .config || echo "Kconfig_style_config error setting $CONFIG_PARAM=$setting"
			if [ -z "$( grep ^$CONFIG_PARAM= .config )" ] ; then
				echo "$CONFIG_PARAM=$setting" >>.config
			fi
		else
			#ensure item commented out
			sed -i "/^$CONFIG_PARAM\>/s/$CONFIG_PARAM/# $CONFIG_PARAM/" .config || echo "Kconfig_style_config error commenting $CONFIG_PARAM"
		fi
}

src_prepare() {
	# net/bpf.h needed for net-libs/libpcap on Gentoo/FreeBSD
	sed -i \
		-e "s:\(#include <pcap\.h>\):#include <net/bpf.h>\n\1:" \
		../src/l2_packet/l2_packet_freebsd.c || die

	# People seem to take the example configuration file too literally (bug #102361)
	sed -i \
		-e "s:^\(opensc_engine_path\):#\1:" \
		-e "s:^\(pkcs11_engine_path\):#\1:" \
		-e "s:^\(pkcs11_module_path\):#\1:" \
		wpa_supplicant.conf || die

	# Change configuration to match Gentoo locations (bug #143750)
	sed -i \
		-e "s:/usr/lib/opensc:/usr/$(get_libdir):" \
		-e "s:/usr/lib/pkcs11:/usr/$(get_libdir):" \
		wpa_supplicant.conf || die

	# systemd entries to D-Bus service files (bug #372877)
	# echo 'SystemdService=wpa_supplicant.service' \
	# 	| tee -a dbus/*.service >/dev/null || die

	cd "${WORKDIR}/${P}" || die

	if use wimax; then
		# generate-libeap-peer.patch comes before
		# fix-undefined-reference-to-random_get_bytes.patch
		# epatch "${FILESDIR}/${P}-generate-libeap-peer.patch"

		# multilib-strict fix (bug #373685)
		sed -e "s/\/usr\/lib/\/usr\/$(get_libdir)/" -i src/eap_peer/Makefile || die
	fi

	# bug (320097)
	# epatch "${FILESDIR}/${P}-do-not-call-dbus-functions-with-NULL-path.patch"

	# TODO - NEED TESTING TO SEE IF STILL NEEDED, NOT COMPATIBLE WITH 1.0 OUT OF THE BOX,
	# SO WOULD BE NICE TO JUST DROP IT, IF IT IS NOT NEEDED.
	# bug (374089)
	#epatch "${FILESDIR}/${P}-dbus-WPAIE-fix.patch"

	# bug (565270)
	# epatch "${FILESDIR}/${P}-libressl.patch"
	default
}

src_configure() {
	sanitizers-setup-env
	# Toolchain setup
	append-flags -Werror
	tc-export CC

	cp defconfig .config || die

	# Basic setup
	Kconfig_style_config CTRL_IFACE
	Kconfig_style_config MATCH_IFACE
	Kconfig_style_config BACKEND file
	Kconfig_style_config IBSS_RSN
	Kconfig_style_config IEEE80211W
	Kconfig_style_config IEEE80211R
	Kconfig_style_config IEEE80211N
	Kconfig_style_config IEEE80211AC
	Kconfig_style_config HT_OVERRIDES
	Kconfig_style_config VHT_OVERRIDES
	Kconfig_style_config OCV
	Kconfig_style_config TLSV11
	Kconfig_style_config TLSV12
	Kconfig_style_config GETRANDOM

	# Basic authentication methods
	# NOTE: we don't set GPSK or SAKE as they conflict
	# with the below options
	Kconfig_style_config EAP_GTC
	Kconfig_style_config EAP_MD5
	Kconfig_style_config EAP_OTP
	Kconfig_style_config EAP_PAX
	Kconfig_style_config EAP_PSK
	Kconfig_style_config EAP_TLV
	Kconfig_style_config EAP_EXE
	Kconfig_style_config IEEE8021X_EAPOL
	Kconfig_style_config PKCS12
	Kconfig_style_config PEERKEY
	Kconfig_style_config EAP_LEAP
	Kconfig_style_config EAP_MSCHAPV2
	Kconfig_style_config EAP_PEAP
	Kconfig_style_config EAP_TEAP
	Kconfig_style_config EAP_TLS
	Kconfig_style_config EAP_TTLS

	# Enabling background scanning.
	Kconfig_style_config BGSCAN_SIMPLE
	Kconfig_style_config BGSCAN_LEARN

	if use dbus ; then
		Kconfig_style_config CTRL_IFACE_DBUS
		Kconfig_style_config CTRL_IFACE_DBUS_NEW
		Kconfig_style_config CTRL_IFACE_DBUS_INTRO
	else
		Kconfig_style_config CTRL_IFACE_DBUS n
		Kconfig_style_config CTRL_IFACE_DBUS_NEW n
		Kconfig_style_config CTRL_IFACE_DBUS_INTRO n
	fi

	# Enable support for writing debug info to a log file and syslog.
	Kconfig_style_config DEBUG_FILE
	Kconfig_style_config DEBUG_SYSLOG
	Kconfig_style_config DEBUG_SYSLOG_FACILITY LOG_LOCAL6

	if use hs2-0 ; then
		Kconfig_style_config INTERWORKING
		Kconfig_style_config HS20
	fi

	# Enable support for MBO (Multi-Band Operation), see
	# https://www.wi-fi.org/discover-wi-fi/wi-fi-agile-multiband
	if use mbo ; then
		Kconfig_style_config MBO
	else
		Kconfig_style_config MBO n
	fi

	if use uncommon-eap-types; then
		Kconfig_style_config EAP_GPSK
		Kconfig_style_config EAP_SAKE
		Kconfig_style_config EAP_GPSK_SHA256
		Kconfig_style_config EAP_IKEV2
		Kconfig_style_config EAP_EKE
	fi

	if use eap-sim ; then
		# Smart card authentication
		Kconfig_style_config EAP_SIM
		Kconfig_style_config EAP_AKA
		Kconfig_style_config EAP_AKA_PRIME
		# CHROMIUM: We don't have smartcard support. Instead include the
		# client library for external processing via the control interface.
		# Kconfig_style_config PCSC
		Kconfig_style_config BUILD_WPA_CLIENT_SO
	fi

	if use readline ; then
		# readline/history support for wpa_cli
		Kconfig_style_config READLINE
	else
		#internal line edit mode for wpa_cli
		Kconfig_style_config WPA_CLI_EDIT
	fi

	Kconfig_style_config TLS openssl
	Kconfig_style_config FST
	if ! use bindist || use libressl; then
		Kconfig_style_config EAP_PWD
		#WPA3
		Kconfig_style_config OWE
		Kconfig_style_config SAE
		Kconfig_style_config DPP
		Kconfig_style_config SUITEB192
	fi
	if ! use bindist && ! use libressl; then
		Kconfig_style_config SUITEB
	fi

	if use smartcard ; then
		Kconfig_style_config SMARTCARD
	else
		Kconfig_style_config SMARTCARD n
	fi

	if use tdls ; then
		Kconfig_style_config TDLS
	fi

	if use kernel_linux ; then
		# Linux specific drivers
		# Kconfig_style_config DRIVER_ATMEL
		# Kconfig_style_config DRIVER_HOSTAP
		# Kconfig_style_config DRIVER_IPW
		Kconfig_style_config DRIVER_NL80211
		# Kconfig_style_config DRIVER_RALINK
		Kconfig_style_config DRIVER_WEXT
		Kconfig_style_config DRIVER_WIRED

		if use ps3 ; then
			Kconfig_style_config DRIVER_PS3
		fi

	elif use kernel_FreeBSD ; then
		# FreeBSD specific driver
		Kconfig_style_config DRIVER_BSD
	fi

	# Wi-Fi Protected Setup (WPS)
	if use wps ; then
		Kconfig_style_config WPS
		Kconfig_style_config WPS2
		# USB Flash Drive
		Kconfig_style_config WPS_UFD
		# External Registrar
		Kconfig_style_config WPS_ER
		# Universal Plug'n'Play
		Kconfig_style_config WPS_UPNP
		# Near Field Communication
		Kconfig_style_config WPS_NFC
	else
		Kconfig_style_config WPS n
		Kconfig_style_config WPS2 n
		Kconfig_style_config WPS_UFD n
		Kconfig_style_config WPS_ER n
		Kconfig_style_config WPS_UPNP n
		Kconfig_style_config WPS_NFC n
	fi

	# Wi-Fi Direct (WiDi)
	if use p2p ; then
		Kconfig_style_config P2P
		Kconfig_style_config WIFI_DISPLAY
	else
		Kconfig_style_config P2P n
		Kconfig_style_config WIFI_DISPLAY n
	fi

	# Access Point Mode
	if use ap ; then
		Kconfig_style_config AP
		# only AP currently support mesh networks.
		Kconfig_style_config MESH
	else
		# (ChromeOS) Explicitly disable to override enabling from defconfig.
		Kconfig_style_config AP        n
		Kconfig_style_config MESH      n
	fi

	# Enable mitigation against certain attacks against TKIP
	Kconfig_style_config DELAYED_MIC_ERROR_REPORT

	# Turn on 802.11v Wireless Network Management
	if use wnm ; then
		Kconfig_style_config WNM
	else
		Kconfig_style_config WNM       n
	fi

	if use qt5 ; then
		pushd "${S}"/wpa_gui-qt4 > /dev/null || die
		eqmake5 wpa_gui.pro
		popd > /dev/null || die
	fi
}

src_compile() {
	einfo "Building wpa_supplicant"
	emake V=1 BINDIR=/usr/sbin

	if use wimax; then
		emake -C ../src/eap_peer clean
		emake -C ../src/eap_peer
	fi

	if use qt5; then
		einfo "Building wpa_gui"
		emake -C "${S}"/wpa_gui-qt4
	fi
}

src_install() {
	dosbin wpa_supplicant
	dobin wpa_cli wpa_passphrase

	# baselayout-1 compat
	if has_version "<sys-apps/baselayout-2.0.0"; then
		dodir /sbin
		dosym /usr/sbin/wpa_supplicant /sbin/wpa_supplicant
		dodir /bin
		dosym /usr/bin/wpa_cli /bin/wpa_cli
	fi

	if has_version ">=sys-apps/openrc-0.5.0"; then
		newinitd "${FILESDIR}/${PN}-init.d" wpa_supplicant
		newconfd "${FILESDIR}/${PN}-conf.d" wpa_supplicant
	fi

	dodoc ChangeLog {eap_testing,todo}.txt README{,-WPS} \
		wpa_supplicant.conf

	newdoc .config build-config

	if use qt5 ; then
		into /usr
		dobin wpa_gui-qt4/wpa_gui
		doicon wpa_gui-qt4/icons/wpa_gui.svg
		make_desktop_entry wpa_gui "WPA Supplicant Administration GUI" "wpa_gui" "Qt;Network;"
	fi

	use wimax && emake DESTDIR="${D}" -C ../src/eap_peer install

	if use eap-sim ; then
		# Install this library and header for the external processor.
		dolib.so libwpa_client.so

		insinto /usr/include/wpa_supplicant
		doins ../src/common/wpa_ctrl.h
	fi

	if use dbus ; then
		# DBus introspection XML file.
		insinto /usr/share/dbus-1/interfaces
		doins ${FILESDIR}/dbus_bindings/fi.w1.wpa_supplicant1.xml || die
		insinto /etc/dbus-1/system.d
		# Allow (but don't require) wpa_supplicant to run as root only
		# when building hwsim targets.
		if use wifi_hostap_test; then
			newins "${FILESDIR}"/dbus_permissions/root_fi.w1.wpa_supplicant1.conf \
				fi.w1.wpa_supplicant1.conf
		else
			doins "${FILESDIR}"/dbus_permissions/fi.w1.wpa_supplicant1.conf
		fi
	fi
	# Install the init scripts
	if use systemd; then
		insinto /usr/share
		systemd_dounit ${FILESDIR}/init/wpasupplicant.service
		systemd_enable_service boot-services.target wpasupplicant.service
		systemd_dotmpfilesd ${FILESDIR}/init/wpasupplicant-directories.conf
	else
		insinto /etc/init
		doins ${FILESDIR}/init/wpasupplicant.conf
		if use seccomp; then
			local policy="${FILESDIR}/seccomp/wpa_supplicant-${ARCH}.policy"
			local policy_out="${ED}/usr/share/policy/wpa_supplicant.bpf"
			dodir /usr/share/policy
			compile_seccomp_policy \
				--arch-json "${SYSROOT}/build/share/constants.json" \
				--default-action trap "${policy}" "${policy_out}" \
				|| die "failed to compile seccomp policy ${policy}"
		else
			sed -i '/^env seccomp_flags=/s:=.*:="":' \
				"${ED}"/etc/init/wpasupplicant.conf || die
		fi
	fi
}

pkg_preinst() {
	enewuser "wpa"
	enewgroup "wpa"
}

pkg_postinst() {
	if [[ -e ${ROOT}etc/wpa_supplicant.conf ]] ; then
		echo
		ewarn "WARNING: your old configuration file ${ROOT}etc/wpa_supplicant.conf"
		ewarn "needs to be moved to ${ROOT}etc/wpa_supplicant/wpa_supplicant.conf"
	fi

	if use bindist; then
		if ! use libressl; then
			ewarn "Using bindist use flag presently breaks WPA3 (specifically SAE, OWE, DPP, and FILS)."
			ewarn "This is incredibly undesirable"
		fi
	fi
	if use libressl; then
		ewarn "Libressl doesn't support SUITEB (part of WPA3)"
		ewarn "but it does support SUITEB192 (the upgraded strength version of the same)"
		ewarn "You probably don't care.  Patches welcome"
	fi
}
