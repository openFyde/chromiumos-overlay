# Copyright 2014 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=6
CROS_WORKON_COMMIT="ca9e4b3e06d7e306777e23c7cf34d8ef2dc6a94f"
CROS_WORKON_TREE=("fb04314ba38f1b698a2ef2ac7178c9dffddfad70" "effea2161564d65a57ce37bb46551a7193f3596e" "dc1506ef7c8cfd2c5ffd1809dac05596ec18773c")
CROS_WORKON_INCREMENTAL_BUILD="1"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk debugd .gn"

PLATFORM_SUBDIR="debugd"

inherit cros-workon platform user

DESCRIPTION="Chrome OS debugging service"
HOMEPAGE="http://www.chromium.org/"
LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE="iwlwifi_dump tpm"

COMMON_DEPEND="
	chromeos-base/chromeos-login
	chromeos-base/minijail
	chromeos-base/chromeos-ssh-testkeys
	chromeos-base/chromeos-sshd-init
	chromeos-base/libbrillo
	chromeos-base/shill-client
	chromeos-base/vboot_reference
	!chromeos-base/workarounds
	dev-libs/libpcre
	dev-libs/protobuf:=
	net-libs/libpcap
	net-wireless/iw
	sys-apps/iproute2
	sys-apps/memtester
	sys-apps/rootdev
	sys-apps/smartmontools
"
RDEPEND="${COMMON_DEPEND}
	iwlwifi_dump? ( chromeos-base/intel-wifi-fw-dump )
"
DEPEND="${COMMON_DEPEND}
	chromeos-base/chromeos-login
	chromeos-base/debugd-client
	chromeos-base/system_api
	sys-apps/dbus"

pkg_preinst() {
	enewuser "debugd"
	enewgroup "debugd"
	enewuser "debugd-logs"
	enewgroup "debugd-logs"

	enewgroup "daemon-store"
	enewgroup "logs-access"
}

src_install() {
	dobin "${OUT}"/generate_logs

	into /
	dosbin "${OUT}"/debugd

	exeinto /usr/libexec/debugd/helpers
	doexe "${OUT}"/capture_packets
	doexe "${OUT}"/cups_uri_helper
	doexe "${OUT}"/dev_features_chrome_remote_debugging
	doexe "${OUT}"/dev_features_password
	doexe "${OUT}"/dev_features_rootfs_verification
	doexe "${OUT}"/dev_features_ssh
	doexe "${OUT}"/dev_features_usb_boot
	doexe "${OUT}"/icmp
	doexe "${OUT}"/netif
	doexe "${OUT}"/network_status

	doexe src/helpers/{capture_utility,minijail-setuid-hack,systrace}.sh

	local debugd_seccomp_dir="src/helpers/seccomp"

	# Install scheduler configuration helper and seccomp policy.
	if use amd64 ; then
		exeinto /usr/libexec/debugd/helpers
		doexe "${OUT}"/scheduler_configuration_helper

		insinto /usr/share/policy
		newins "${debugd_seccomp_dir}/scheduler-configuration-helper-${ARCH}.policy" scheduler-configuration-helper.policy
	fi

	# Install seccomp policy for the CUPS URI helper.
	insinto /usr/share/policy
	newins "${debugd_seccomp_dir}/cups-uri-helper-${ARCH}.policy" \
		cups-uri-helper.policy


	# Install DBus configuration.
	insinto /etc/dbus-1/system.d
	doins share/org.chromium.debugd.conf

	insinto /etc/init
	doins share/{debugd,trace_marker-test}.conf

	insinto /etc/perf_commands
	doins -r share/perf_commands/*
}

platform_pkg_test() {
	pushd "${S}/src" >/dev/null
	platform_test "run" "${OUT}/debugd_testrunner"
	./helpers/capture_utility_test.sh || die
	popd >/dev/null
}
