# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
# TODO(crbug.com/809389): Avoid directly including headers from other packages.
CROS_WORKON_SUBTREE="common-mk chromeos-config rmad .gn"

PLATFORM_SUBDIR="rmad"

inherit cros-workon platform tmpfiles user

DESCRIPTION="ChromeOS RMA daemon."
HOMEPAGE=""

LICENSE="BSD-Google"
KEYWORDS="~*"
IUSE="cr50_onboard ti50_onboard generated_cros_config unibuild"

COMMON_DEPEND="
	unibuild? (
		!generated_cros_config? ( chromeos-base/chromeos-config:= )
		generated_cros_config? ( chromeos-base/chromeos-config-bsp:= )
	)
	chromeos-base/chromeos-config-tools:=
	chromeos-base/cryptohome-client:=
"

RDEPEND="
	${COMMON_DEPEND}
	cr50_onboard? ( chromeos-base/chromeos-cr50 )
	ti50_onboard? ( chromeos-base/chromeos-ti50 )
	chromeos-base/croslog
	chromeos-base/runtime_probe
"

DEPEND="
	${COMMON_DEPEND}
	chromeos-base/system_api
	chromeos-base/vboot_reference
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
