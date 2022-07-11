# Copyright 2014 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="55fe26b58c0a6458f452b79307b61ad101e911ab"
CROS_WORKON_TREE=("02bfff6bead7011dd0b16a3393e99a677d8e4e0e" "c49ded682c460b93ab7b096a29a9d0ea2ad31cf0" "b3d40dd8b9633e85d00396246f41d742729a1b8b" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD="1"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk debugd metrics .gn"

PLATFORM_SUBDIR="debugd"

inherit cros-workon platform tmpfiles user

DESCRIPTION="Chrome OS debugging service"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/debugd/"
LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="arcvm cellular iwlwifi_dump nvme sata tpm ufs"

COMMON_DEPEND="
	chromeos-base/chromeos-login:=
	chromeos-base/cryptohome-client:=
	chromeos-base/minijail:=
	chromeos-base/metrics:=
	chromeos-base/shill-client:=
	chromeos-base/vboot_reference:=
	dev-libs/protobuf:=
	dev-libs/re2:=
	net-libs/libpcap:=
	net-wireless/iw:=
	sys-apps/rootdev:=
	sys-libs/libcap:=
	sata? ( sys-apps/smartmontools:= )
"
RDEPEND="${COMMON_DEPEND}
	iwlwifi_dump? ( chromeos-base/intel-wifi-fw-dump )
	nvme? ( sys-apps/nvme-cli )
	ufs? (
		sys-apps/sg3_utils
		sys-apps/ufs-utils
	)
	chromeos-base/chromeos-ssh-testkeys
	chromeos-base/chromeos-sshd-init
	!chromeos-base/workarounds
	sys-apps/iproute2
	sys-apps/memtester
"
DEPEND="${COMMON_DEPEND}
	chromeos-base/debugd-client:=
	chromeos-base/system_api:=
	sys-apps/dbus:="

pkg_setup() {
	# Has to be done in pkg_setup() instead of pkg_preinst() since
	# src_install() needs debugd.
	enewuser "debugd"
	enewgroup "debugd"

	cros-workon_pkg_setup
}

pkg_preinst() {
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
	doexe "${OUT}"/audit_log_filter
	doexe "${OUT}"/capture_packets
	doexe "${OUT}"/cups_uri_helper
	doexe "${OUT}"/dev_features_chrome_remote_debugging
	doexe "${OUT}"/dev_features_password
	doexe "${OUT}"/dev_features_rootfs_verification
	doexe "${OUT}"/dev_features_ssh
	doexe "${OUT}"/dev_features_usb_boot
	doexe "${OUT}"/folder_size_dump
	doexe "${OUT}"/icmp
	doexe "${OUT}"/modetest_helper
	doexe "${OUT}"/netif
	doexe "${OUT}"/network_status
	doexe "${OUT}"/typec_connector_class_helper
	doexe "${OUT}"/usb4_devinfo_helper
	doexe "${OUT}"/bt_usb_disconnect_helper

	doexe src/helpers/{capture_utility,minijail-setuid-hack,systrace}.sh

	local debugd_seccomp_dir="src/helpers/seccomp"

	# Install scheduler configuration helper and seccomp policy.
	if use amd64 ; then
		exeinto /usr/libexec/debugd/helpers
		doexe "${OUT}"/scheduler_configuration_helper
	fi

	# Install seccomp policies.
	insinto /usr/share/policy
	local policy
	for policy in "${debugd_seccomp_dir}"/*-"${ARCH}".policy; do
		local policy_basename="${policy##*/}"
		local policy_name="${policy_basename/-${ARCH}}"
		newins "${policy}" "${policy_name}"
	done


	# Install DBus configuration.
	insinto /etc/dbus-1/system.d
	doins share/org.chromium.debugd.conf

	insinto /etc/init
	doins share/{debugd,trace_marker-test}.conf share/kernel-features.json

	insinto /etc/perf_commands
	doins -r share/perf_commands/*

	dotmpfiles tmpfiles.d/*.conf

	local daemon_store="/etc/daemon-store/debugd"
	dodir "${daemon_store}"
	fperms 0660 "${daemon_store}"
	fowners debugd:debugd "${daemon_store}"

	local fuzzer_component_id="960619"
	platform_fuzzer_install "${S}"/OWNERS \
			"${OUT}"/debugd_cups_uri_helper_utils_fuzzer \
			--comp "${fuzzer_component_id}"
}

platform_pkg_test() {
	pushd "${S}/src" >/dev/null || die
	platform_test "run" "${OUT}/debugd_testrunner"
	./helpers/capture_utility_test.sh || die
	popd >/dev/null || die
}
