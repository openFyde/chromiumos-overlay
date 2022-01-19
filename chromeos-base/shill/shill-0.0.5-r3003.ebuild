# Copyright 2014 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="a6bcc1f386bfb9b12ce3ab8a4acde333df421f8a"
CROS_WORKON_TREE=("870be7e0752a4ee27e6ed09c6fc7e2a5f11ae344" "8bfa107b3615ee562012f6589e81d78ab47a1cd2" "56dc9b3a788bc68f829c1e7a1d3b6cf067c7aaf9" "64cdc1ea3bcf5a4fe036b8d4a08f1b329dd967f5" "9f67d9ca52d70ab9ec5993672f5adb7286502015" "5277c98d28375e59faa9d2834904f94563715ce0" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
# TODO(crbug.com/809389): Avoid directly including headers from other packages.
CROS_WORKON_SUBTREE="common-mk chaps libpasswordprovider metrics shill vpn-manager .gn"

PLATFORM_SUBDIR="shill"

inherit cros-workon platform systemd tmpfiles udev user

DESCRIPTION="Shill Connection Manager for Chromium OS"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/shill/"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="cellular dhcpv6 fuzzer pppoe sae_h2e systemd +tpm +vpn +wake_on_wifi +wifi +wired_8021x +wpa3_sae +wireguard"

# Sorted by the package we depend on. (Not by use flag!)
COMMON_DEPEND="
	chromeos-base/bootstat:=
	chromeos-base/chaps:=
	chromeos-base/minijail:=
	chromeos-base/libpasswordprovider:=
	>=chromeos-base/metrics-0.0.1-r3152:=
	chromeos-base/nsswitch:=
	chromeos-base/patchpanel-client:=
	chromeos-base/shill-net:=
	dev-libs/re2:=
	cellular? ( net-dialup/ppp:= )
	pppoe? ( net-dialup/ppp:= )
	vpn? ( net-dialup/ppp:= )
	net-dns/c-ares:=
	net-libs/libtirpc:=
	net-firewall/conntrack-tools:=
	net-firewall/iptables:=
	wifi? ( virtual/wpa_supplicant )
	wired_8021x? ( virtual/wpa_supplicant )
	sys-apps/rootdev:=
	cellular? ( net-misc/modemmanager-next:= )
"

RDEPEND="${COMMON_DEPEND}
	net-misc/dhcpcd
	dhcpv6? ( net-misc/dhcpcd[ipv6] )
	vpn? ( net-vpn/openvpn )
	wireguard? ( net-vpn/wireguard-tools )
"
DEPEND="${COMMON_DEPEND}
	chromeos-base/shill-client:=
	chromeos-base/power_manager-client:=
	chromeos-base/system_api:=[fuzzer?]
	vpn? ( chromeos-base/vpn-manager:= )
"
PDEPEND="chromeos-base/patchpanel"

REQUIRED_USE="
	fuzzer? ( wifi )
"

pkg_setup() {
	enewgroup "shill"
	enewuser "shill"
	cros-workon_pkg_setup
}

pkg_preinst() {
	enewgroup "shill-crypto"
	enewuser "shill-crypto"
	enewgroup "shill-scripts"
	enewuser "shill-scripts"
	enewgroup "nfqueue"
	enewuser "nfqueue"
	enewgroup "vpn"
	enewuser "vpn"
}

get_dependent_services() {
	local dependent_services=()
	if use wifi || use wired_8021x; then
		dependent_services+=(wpasupplicant)
	fi
	if use systemd; then
		echo "network-services.service ${dependent_services[*]/%/.service }"
	else
		echo "started network-services " \
			"${dependent_services[*]/#/and started }"
	fi
}

src_configure() {
	cros_optimize_package_for_speed
	platform_src_configure
}

src_install() {
	platform_src_install

	dobin bin/ff_debug

	if use cellular; then
		dobin bin/set_apn
		dobin bin/set_cellular_ppp
	fi

	dosbin bin/set_wifi_regulatory
	dobin bin/set_arpgw
	dobin bin/set_wake_on_lan
	dobin bin/shill_login_user
	dobin bin/shill_logout_user
	if use wifi || use wired_8021x; then
		dobin bin/wpa_debug
	fi
	dobin "${OUT}"/shill

	local shims_dir=/usr/$(get_libdir)/shill/shims
	exeinto "${shims_dir}"

	use vpn && doexe "${OUT}"/openvpn-script
	if use cellular || use pppoe || use vpn; then
		newexe "${OUT}"/lib/libshill-pppd-plugin.so shill-pppd-plugin.so
	fi

	use cellular && doexe "${OUT}"/set-apn-helper

	if use wifi || use wired_8021x; then
		sed \
			"s,@libdir@,/usr/$(get_libdir)", \
			shims/wpa_supplicant.conf.in \
			> "${D}/${shims_dir}/wpa_supplicant.conf"
	fi

	if use sae_h2e; then
		# If supplicant's version is recent enough (July 2021 rebase
		# or newer), change the default value of sae_pwe to support both
		# hunting-and-pecking and hash-to-element, which is required
		# for newer standards.
		echo "sae_pwe=2" >> "${D}/${shims_dir}/wpa_supplicant.conf"
	fi

	dosym /run/shill/resolv.conf /etc/resolv.conf
	insinto /etc/dbus-1/system.d
	doins shims/org.chromium.flimflam.conf

	if use cellular; then
		insinto /usr/share/shill
		doins "${OUT}"/serviceproviders.pbf
		insinto /usr/share/protofiles
		doins "${S}/mobile_operator_db/mobile_operator_db.proto"
	fi

	# Install introspection XML
	insinto /usr/share/dbus-1/interfaces
	doins dbus_bindings/org.chromium.flimflam.*.dbus-xml
	doins dbus_bindings/dbus-service-config.json

	# Replace template parameters inside init scripts
	local shill_name="shill.$(usex systemd service conf)"
	sed \
		"s,@expected_started_services@,$(get_dependent_services)," \
		"init/${shill_name}.in" \
		> "${T}/${shill_name}"

	# Install init scripts
	if use systemd; then
		systemd_dounit init/shill-start-user-session.service
		systemd_dounit init/shill-stop-user-session.service

		local dependent_services=$(get_dependent_services)
		systemd_dounit "${T}/shill.service"
		for dependent_service in ${dependent_services}; do
			systemd_enable_service "${dependent_service}" shill.service
		done
		systemd_enable_service shill.service network.target

		systemd_dounit init/network-services.service
		systemd_enable_service boot-services.target network-services.service
	else
		insinto /etc/init

		doins "${T}"/*.conf
		doins \
			init/network-services.conf \
			init/shill-event.conf \
			init/shill-start-user-session.conf \
			init/shill-stop-user-session.conf \
			init/shill_respawn.conf
	fi
	exeinto /usr/share/cros/init
	doexe init/*.sh
	dotmpfiles tmpfiles.d/*.conf

	insinto /usr/share/cros/startup/process_management_policies
	doins setuid_restrictions/shill_uid_allowlist.txt

	udev_dorules udev/*.rules

	# Shill keeps profiles inside the user's cryptohome.
	local daemon_store="/etc/daemon-store/shill"
	dodir "${daemon_store}"
	fperms 0700 "${daemon_store}"
	fowners shill:shill "${daemon_store}"

	local cellular_fuzzer_component_id="167157"
	platform_fuzzer_install "${S}"/OWNERS "${OUT}/cellular_pco_fuzzer" \
		--comp "${cellular_fuzzer_component_id}"
	platform_fuzzer_install "${S}"/OWNERS "${OUT}/verizon_subscription_state_fuzzer" \
		--comp "${cellular_fuzzer_component_id}"

	local wifi_fuzzer_component_id="893827"
	platform_fuzzer_install "${S}"/OWNERS "${OUT}/wifi_ies_fuzzer" \
		--comp "${wifi_fuzzer_component_id}"
	platform_fuzzer_install "${S}"/OWNERS "${OUT}/wifi_service_fuzzer" \
		--comp "${wifi_fuzzer_component_id}"

	local chromeos_platform_connectivity_network_component_id="167325"
	platform_fuzzer_install "${S}"/OWNERS "${OUT}/dhcpv4_static_routes_fuzzer" \
		--comp "${chromeos_platform_connectivity_network_component_id}"
	platform_fuzzer_install "${S}"/OWNERS "${OUT}/shill_profile_fuzzer" \
		--comp "${chromeos_platform_connectivity_network_component_id}"
	platform_fuzzer_install "${S}"/OWNERS "${OUT}/shill_http_url_fuzzer" \
		--comp "${chromeos_platform_connectivity_network_component_id}"
	platform_fuzzer_install "${S}"/OWNERS "${OUT}/shill_service_fuzzer" \
		--comp "${chromeos_platform_connectivity_network_component_id}"
	platform_fuzzer_install "${S}"/OWNERS "${OUT}/shill_technology_fuzzer" \
		--comp "${chromeos_platform_connectivity_network_component_id}"

	if use vpn; then
		local vpn_fuzzer_component_id="156085"
		platform_fuzzer_install "${S}"/OWNERS "${OUT}/openvpn_management_server_fuzzer" \
			--comp "${vpn_fuzzer_component_id}"
		platform_fuzzer_install "${S}"/OWNERS "${OUT}/vpn_ipsec_connection_fuzzer" \
			--comp "${vpn_fuzzer_component_id}"
		platform_fuzzer_install "${S}"/OWNERS "${OUT}/vpn_l2tp_ipsec_driver_fuzzer" \
			--comp "${vpn_fuzzer_component_id}"
	fi
}

platform_pkg_test() {
	platform_test "run" "${OUT}/shill_unittest"
}
