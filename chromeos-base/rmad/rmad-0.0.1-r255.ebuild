# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="4c81debf8db1e288401b6d21394154537c7fd3eb"
CROS_WORKON_TREE=("c0c03d001677e1c1906a8cd05b4e1aa1e16bab49" "32899b1cfd4eeb8ac5bb5f89cde0a82d7c5f9c99" "1b6791d8f3bd43faefbaff3664ccf8eeabdfa502" "c268a0456d93a58f0ec85e803ab01a23eb396035" "7bd2393837bc4162899abba0a3c6977b462df042" "db94b77b7158b1789db0b0258b7ea3eecf3b39bb" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
# TODO(crbug.com/809389): Avoid directly including headers from other packages.
CROS_WORKON_SUBTREE="common-mk chromeos-config hardware_verifier libmems metrics rmad .gn"

PLATFORM_SUBDIR="rmad"

inherit cros-workon cros-unibuild platform tmpfiles user

DESCRIPTION="ChromeOS RMA daemon."
HOMEPAGE=""

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="cr50_onboard iioservice ti50_onboard"

COMMON_DEPEND="
	chromeos-base/chromeos-config-tools:=
	chromeos-base/minijail:=
"

RDEPEND="
	${COMMON_DEPEND}
	cr50_onboard? ( chromeos-base/chromeos-cr50 )
	iioservice? ( chromeos-base/iioservice_simpleclient )
	ti50_onboard? ( chromeos-base/chromeos-ti50 )
	chromeos-base/croslog
	chromeos-base/hardware_verifier
	chromeos-base/libmems
	chromeos-base/runtime_probe
"

DEPEND="
	${COMMON_DEPEND}
	chromeos-base/cryptohome-client:=
	chromeos-base/metrics:=
	chromeos-base/shill-client:=
	chromeos-base/system_api:=
	chromeos-base/tpm_manager-client:=
	chromeos-base/vboot_reference:=
"

pkg_preinst() {
	# Create user and group for RMA.
	enewuser "rmad"
	enewgroup "rmad"
}

src_install() {
	dosbin "${OUT}/rmad"

	dotmpfiles tmpfiles.d/*.conf

	# Install upstart configs and scripts.
	insinto /etc/init
	doins init/*.conf

	# Install D-Bus configuration file.
	insinto /etc/dbus-1/system.d
	doins dbus/org.chromium.Rmad.conf

	# Install D-Bus service activation configuration.
	insinto /usr/share/dbus-1/system-services
	doins dbus/org.chromium.Rmad.service

	# Install seccomp policy file.
	insinto /usr/share/policy
	newins "seccomp/rmad-seccomp-${ARCH}.policy" rmad-seccomp.policy
}

platform_pkg_test() {
	platform_test "run" "${OUT}/rmad_test"
}
