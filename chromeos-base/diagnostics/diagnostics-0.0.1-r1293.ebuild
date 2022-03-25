# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="33218561b5b0b783e5e755c45944a30813c116e4"
CROS_WORKON_TREE=("32b4e8dd008b53110288d6ab187104a92b405c89" "aad456d8caa74b8d95e4279190d11b6e8e973cc9" "5925477eb5b106ecf4079af6be9c8e320a5ece9e" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_DESTDIR="${S}/platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
# TODO(crbug.com/1044813): Remove chromeos-config once its public headers are fixed.
CROS_WORKON_SUBTREE="common-mk chromeos-config diagnostics .gn"

PLATFORM_SUBDIR="diagnostics"

inherit cros-workon cros-unibuild platform udev user

DESCRIPTION="Device telemetry and diagnostics for Chrome OS"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/diagnostics"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="fuzzer wilco mesa_reven"

# TODO(204734015): Remove app-arch/zstd:=.
COMMON_DEPEND="
	chromeos-base/chromeos-config-tools:=
	chromeos-base/minijail:=
	chromeos-base/missive:=
	dev-libs/protobuf:=
	dev-libs/re2:=
	net-libs/grpc:=
	virtual/libudev:=
	sys-apps/pciutils:=
	virtual/libusb:1=
	virtual/opengles:=
	app-arch/zstd:=
"

DEPEND="
	${COMMON_DEPEND}
	chromeos-base/attestation-client:=
	chromeos-base/debugd-client:=
	chromeos-base/tpm_manager-client:=
	chromeos-base/system_api:=[fuzzer?]
	media-sound/adhd:=
	x11-drivers/opengles-headers:=
"

# TODO(crbug/1085169): Replace sys-block/fio dependency with an alternative as
# it is very large. It is currently only a dependency of wilco as it is
# currently the only client.
RDEPEND="
	${COMMON_DEPEND}
	dev-util/stressapptest
	wilco? (
		sys-block/fio
		chromeos-base/chromeos-dtc-vm
		chromeos-base/vpd
	)
"

# @FUNCTION: inst_seccomp
# @USAGE: <policy-file-path>
# @DESCRIPTION:
# Given a seccomp policy file <policy-file-path>, compile it, and install it
# into current install location.
inst_seccomp() {
	local path="$1"
	local arch_path="${path%.policy}-${ARCH}.policy"
	local file="$(basename "${path}")"

	compile_seccomp_policy \
		--arch-json "${SYSROOT}/build/share/constants.json" \
		"${arch_path}" /dev/null \
		|| die "failed to compile seccomp policy ${arch_path}"
	newins "${arch_path}" "${file}"
	einfo "The seccomp policy file ${arch_path} was installed successfully as ${file}."
}

pkg_preinst() {
	enewgroup cros_ec-access
	enewuser cros_healthd
	enewgroup cros_healthd
	enewuser healthd_ec
	enewgroup healthd_ec

	if use wilco; then
		enewuser wilco_dtc
		enewgroup wilco_dtc
	fi
}

src_install() {
	dobin "${OUT}/cros_healthd"
	dobin "${OUT}/cros-health-tool"

	if use wilco; then
		dobin "${OUT}/wilco_dtc_supportd"

		# Install seccomp policy files.
		insinto /usr/share/policy
		inst_seccomp "init/wilco_dtc_supportd-seccomp.policy"
		inst_seccomp "init/wilco-dtc-e2fsck-seccomp.policy"
		inst_seccomp "init/wilco-dtc-resize2fs-seccomp.policy"

		# Install D-Bus configuration file.
		insinto /etc/dbus-1/system.d
		doins dbus/org.chromium.WilcoDtcSupportd.conf
		doins dbus/WilcoDtcUpstart.conf

		# Install the init scripts.
		insinto /etc/init
		doins init/wilco_dtc_dispatcher.conf
		doins init/wilco_dtc_supportd.conf
		doins init/wilco_dtc.conf

		# Install udev rules.
		udev_dorules udev/99-ec_driver_files.rules
	fi

	# Install seccomp policy files.
	insinto /usr/share/policy
	inst_seccomp "init/cros_healthd-seccomp.policy"
	inst_seccomp "cros_healthd/seccomp/ectool_i2cread-seccomp.policy"
	inst_seccomp "cros_healthd/seccomp/ectool_pwmgetfanrpm-seccomp.policy"
	inst_seccomp "cros_healthd/seccomp/memtester-seccomp.policy"
	inst_seccomp "cros_healthd/seccomp/iw-seccomp.policy"

	# Install D-Bus configuration file.
	insinto /etc/dbus-1/system.d
	doins dbus/org.chromium.CrosHealthd.conf

	# Install the init scripts.
	insinto /etc/init
	doins init/cros_healthd.conf

	# Install the diagnostic routine executables.
	exeinto /usr/libexec/diagnostics
	doexe "${OUT}/floating-point-accuracy"
	doexe "${OUT}/prime-search"
	doexe "${OUT}/smartctl-check"
	doexe "${OUT}/urandom"

	# Install udev rules.
	udev_dorules udev/99-chown_dmi_dir.rules

	# Install fuzzers.
	local fuzzer_component_id="982097"
	platform_fuzzer_install "${S}"/OWNERS "${OUT}"/fetch_system_info_fuzzer \
		--comp "${fuzzer_component_id}"
}

platform_pkg_test() {
	local tests=(
		cros_healthd_test
	)
	if use wilco; then
		tests+=(
			wilco_dtc_supportd_test
		)
	fi

	local test_bin
	for test_bin in "${tests[@]}"; do
		platform_test "run" "${OUT}/${test_bin}"
	done
}
