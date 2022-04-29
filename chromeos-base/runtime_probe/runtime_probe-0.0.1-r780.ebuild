# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="c5f618f32998da447536e8aadcdc41cc3f37e0f3"
CROS_WORKON_TREE=("8862066a1f139e245f2b384a6818b5365f0790f3" "d45a4a710d6730b7167433f809bd94490fc69021" "8260549462437fb9351a5bc1b41735bc3dcf9acc" "9890f067cb249e701d8da38c598d0c047c0c943d" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk chromeos-config libec runtime_probe .gn"

PLATFORM_SUBDIR="runtime_probe"

inherit cros-workon cros-unibuild platform user udev

DESCRIPTION="Runtime probing on device componenets."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/runtime_probe/"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="asan fuzzer"

COMMON_DEPEND="
	chromeos-base/chromeos-config-tools:=
"

RDEPEND="
	${COMMON_DEPEND}
	chromeos-base/ec-utils
"

# Add vboot_reference as build time dependency to read cros_debug status
DEPEND="${COMMON_DEPEND}
	chromeos-base/debugd-client:=
	chromeos-base/libec:=
	chromeos-base/shill-client:=
	chromeos-base/system_api:=[fuzzer?]
	chromeos-base/vboot_reference:=
"

pkg_preinst() {
	# Create user and group for runtime_probe
	enewuser "runtime_probe"
	enewgroup "cros_ec-access"
	enewgroup "runtime_probe"
}

src_install() {
	platform_src_install

	dobin "${OUT}/runtime_probe"

	# Install upstart configs and scripts.
	insinto /etc/init
	doins init/*.conf

	# Install D-Bus configuration file.
	insinto /etc/dbus-1/system.d
	doins dbus/org.chromium.RuntimeProbe.conf

	# Install D-Bus service activation configuration.
	insinto /usr/share/dbus-1/system-services
	doins dbus/org.chromium.RuntimeProbe.service


	# Install sandbox information.
	insinto /etc/runtime_probe/sandbox
	doins sandbox/"${ARCH}"/args.json
	doins sandbox/"${ARCH}"/*-seccomp.policy

	# Install seccomp policy file.
	insinto /usr/share/policy
	newins "seccomp/runtime_probe-seccomp-${ARCH}.policy" \
	runtime_probe-seccomp.policy

	# Install udev rules.
	udev_dorules udev/*.rules

	local fuzzer
	for fuzzer in "${OUT}"/*_fuzzer; do
		local fuzzer_component_id="606088"
		platform_fuzzer_install "${S}"/OWNERS "${fuzzer}" \
			--comp "${fuzzer_component_id}"
	done
}

platform_pkg_test() {
	platform_test "run" "${OUT}/unittest_runner"
}
