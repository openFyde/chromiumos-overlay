# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
CROS_WORKON_PROJECT="chromiumos/third_party/hostap"
CROS_WORKON_LOCALNAME="../third_party/wpa_supplicant-2.9"

inherit cros-workon toolchain-funcs savedconfig

DESCRIPTION="IEEE 802.11 wireless LAN Host AP daemon"
HOMEPAGE="http://w1.fi"
SRC_URI=""

LICENSE="BSD"
SLOT="0"
KEYWORDS="~*"
IUSE="internal-tls ipv6 libressl logwatch netlink sqlite +wps +crda"

DEPEND="
	libressl? ( dev-libs/libressl:0= )
	!libressl? (
		internal-tls? ( dev-libs/libtommath )
		!internal-tls? ( dev-libs/openssl:0=[-bindist] )
	)
	kernel_linux? (
		dev-libs/libnl:3
		crda? ( net-wireless/crda )
	)
	netlink? ( net-libs/libnfnetlink )
	sqlite? ( >=dev-db/sqlite-3 )"

RDEPEND="${DEPEND}"

src_unpack() {
	cros-workon_src_unpack
	S+="/hostapd"
}

src_configure() {
	if use internal-tls; then
		if use libressl; then
			elog "libressl flag takes precedence over internal-tls"
		else
			ewarn "internal-tls implementation is experimental and provides fewer features"
		fi
	fi

	local CONFIG="${S}/.config"

	restore_config "${CONFIG}"
	if [[ -f "${CONFIG}" ]]; then
		default_src_configure
		return 0
	fi

	# toolchain setup
	echo "CC = $(tc-getCC)" > ${CONFIG}

	# EAP authentication methods
	echo "CONFIG_EAP=y" >> ${CONFIG}
	echo "CONFIG_ERP=y" >> ${CONFIG}
	echo "CONFIG_EAP_MD5=y" >> ${CONFIG}

	if use internal-tls && ! use libressl; then
		echo "CONFIG_TLS=internal" >> ${CONFIG}
	else
		# SSL authentication methods
		echo "CONFIG_EAP_FAST=y" >> ${CONFIG}
		echo "CONFIG_EAP_TLS=y" >> ${CONFIG}
		echo "CONFIG_EAP_TTLS=y" >> ${CONFIG}
		echo "CONFIG_EAP_MSCHAPV2=y" >> ${CONFIG}
		echo "CONFIG_EAP_PEAP=y" >> ${CONFIG}
		echo "CONFIG_TLSV11=y" >> ${CONFIG}
		echo "CONFIG_TLSV12=y" >> ${CONFIG}
		echo "CONFIG_EAP_PWD=y" >> ${CONFIG}
	fi

	if use wps; then
		# Enable Wi-Fi Protected Setup
		echo "CONFIG_WPS=y" >> ${CONFIG}
		echo "CONFIG_WPS2=y" >> ${CONFIG}
		echo "CONFIG_WPS_UPNP=y" >> ${CONFIG}
		echo "CONFIG_WPS_NFC=y" >> ${CONFIG}
		einfo "Enabling Wi-Fi Protected Setup support"
	fi

	echo "CONFIG_EAP_IKEV2=y" >> ${CONFIG}
	echo "CONFIG_EAP_TNC=y" >> ${CONFIG}
	echo "CONFIG_EAP_GTC=y" >> ${CONFIG}
	echo "CONFIG_EAP_SIM=y" >> ${CONFIG}
	echo "CONFIG_EAP_AKA=y" >> ${CONFIG}
	echo "CONFIG_EAP_AKA_PRIME=y" >> ${CONFIG}
	echo "CONFIG_EAP_EKE=y" >> ${CONFIG}
	echo "CONFIG_EAP_FAST=y" >> ${CONFIG}
	echo "CONFIG_EAP_PAX=y" >> ${CONFIG}
	echo "CONFIG_EAP_PSK=y" >> ${CONFIG}
	echo "CONFIG_EAP_SAKE=y" >> ${CONFIG}
	echo "CONFIG_EAP_GPSK=y" >> ${CONFIG}
	echo "CONFIG_EAP_GPSK_SHA256=y" >> ${CONFIG}
	echo "CONFIG_EAP_UNAUTH_TLS=y" >> ${CONFIG}
	echo "CONFIG_EAP_VENDOR_TEST=y" >> ${CONFIG}
	echo "CONFIG_SUITEB=y" >> ${CONFIG}
	echo "CONFIG_SUITEB192=y" >> ${CONFIG}

	einfo "Enabling drivers: "

	# drivers
	echo "CONFIG_DRIVER_HOSTAP=y" >> ${CONFIG}
	einfo "  HostAP driver enabled"
	echo "CONFIG_DRIVER_WIRED=y" >> ${CONFIG}
	einfo "  Wired driver enabled"
	echo "CONFIG_DRIVER_NONE=y" >> ${CONFIG}
	einfo "  None driver enabled"

	einfo "  nl80211 driver enabled"
	echo "CONFIG_DRIVER_NL80211=y" >> ${CONFIG}

	# epoll
	echo "CONFIG_ELOOP_EPOLL=y" >> ${CONFIG}

	# misc
	echo "CONFIG_DEBUG_FILE=y" >> ${CONFIG}
	echo "CONFIG_PKCS12=y" >> ${CONFIG}
	echo "CONFIG_RADIUS_SERVER=y" >> ${CONFIG}
	echo "CONFIG_IAPP=y" >> ${CONFIG}
	echo "CONFIG_IEEE80211R=y" >> ${CONFIG}
	echo "CONFIG_IEEE80211W=y" >> ${CONFIG}
	echo "CONFIG_IEEE80211N=y" >> ${CONFIG}
	echo "CONFIG_IEEE80211AC=y" >> ${CONFIG}
	echo "CONFIG_PEERKEY=y" >> ${CONFIG}
	echo "CONFIG_RSN_PREAUTH=y" >> ${CONFIG}
	echo "CONFIG_INTERWORKING=y" >> ${CONFIG}
	echo "CONFIG_FULL_DYNAMIC_VLAN=y" >> ${CONFIG}
	echo "CONFIG_HS20=y" >> ${CONFIG}
	echo "CONFIG_WNM=y" >> ${CONFIG}
	echo "CONFIG_FST=y" >> ${CONFIG}
	echo "CONFIG_FST_TEST=y" >> ${CONFIG}
	echo "CONFIG_ACS=y" >> ${CONFIG}

	# WPA3
	echo "CONFIG_SAE=y" >> ${CONFIG}

	if use netlink; then
		# Netlink support
		echo "CONFIG_VLAN_NETLINK=y" >> ${CONFIG}
	fi

	if use ipv6; then
		# IPv6 support
		echo "CONFIG_IPV6=y" >> ${CONFIG}
	fi

	if use sqlite; then
		# Sqlite support
		echo "CONFIG_SQLITE=y" >> ${CONFIG}
	fi

	# If we are using libnl 2.0 and above, enable support for it
	# Removed for now, since the 3.2 version is broken, and we don't
	# support it.
	if has_version ">=dev-libs/libnl-3.2"; then
		echo "CONFIG_LIBNL32=y" >> .config
	fi

	# TODO: Add support for BSD drivers

	default
}

src_compile() {
	emake V=1

	if use libressl || ! use internal-tls; then
		emake V=1 nt_password_hash
		emake V=1 hlr_auc_gw
	fi
}

src_install() {
	dosbin ${PN}
	dobin ${PN}_cli

	if use libressl || ! use internal-tls; then
		dobin nt_password_hash hlr_auc_gw
	fi

	doman ${PN}{.8,_cli.1}

	dodoc ChangeLog README
	use wps && dodoc README-WPS

	docinto examples
	dodoc wired.conf

	if use logwatch; then
		insinto /etc/log.d/conf/services/
		doins logwatch/${PN}.conf

		exeinto /etc/log.d/scripts/services/
		doexe logwatch/${PN}
	fi

	save_config .config
}

pkg_postinst() {
	einfo
	einfo "If you are running openRC you need to follow this instructions:"
	einfo "In order to use ${PN} you need to set up your wireless card"
	einfo "for master mode in /etc/conf.d/net and then start"
	einfo "/etc/init.d/${PN}."
	einfo
	einfo "Example configuration:"
	einfo
	einfo "config_wlan0=( \"192.168.1.1/24\" )"
	einfo "channel_wlan0=\"6\""
	einfo "essid_wlan0=\"test\""
	einfo "mode_wlan0=\"master\""
	einfo
	#if [ -e "${KV_DIR}"/net/mac80211 ]; then
	#	einfo "This package now compiles against the headers installed by"
	#	einfo "the kernel source for the mac80211 driver. You should "
	#	einfo "re-emerge ${PN} after upgrading your kernel source."
	#fi

	if use wps; then
		einfo "You have enabled Wi-Fi Protected Setup support, please"
		einfo "read the README-WPS file in /usr/share/doc/${P}"
		einfo "for info on how to use WPS"
	fi
}
