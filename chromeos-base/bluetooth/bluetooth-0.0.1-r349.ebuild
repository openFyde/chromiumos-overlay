# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="aa87ba1a4b38be2ffb16f363e76f0f0fe2eb61bc"
CROS_WORKON_TREE=("c5e851c0a9f693b39a3385a86e1075e6de1ce2e9" "13559c47791e229a4f2ab837214894dc3058ffe1" "631b8872cfedeaebf7ccb6066299af603e3cccbd" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_SUBTREE="common-mk chromeos-config bluetooth .gn"

PLATFORM_SUBDIR="bluetooth"

inherit cros-workon platform

DESCRIPTION="Bluetooth service for Chromium OS"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/bluetooth"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="+bluetooth_suspend_management fuzzer seccomp unibuild"

RDEPEND="
	unibuild? ( chromeos-base/chromeos-config:= )
	chromeos-base/newblue:=
	net-wireless/bluez:=
"

DEPEND="${RDEPEND}
	chromeos-base/system_api:=[fuzzer?]"

src_install() {
	dobin init/scripts/bluetooth-setup.sh
	dobin "${OUT}"/btdispatch
	dobin "${OUT}"/newblued

	insinto /etc/dbus-1/system.d
	doins dbus/org.chromium.Bluetooth.conf
	doins dbus/org.chromium.Newblue.conf

	insinto /etc/init
	doins init/upstart/bluetooth-setup.conf
	doins init/upstart/btdispatch.conf
	doins init/upstart/newblued.conf

	if use seccomp; then
		# Install seccomp policy files.
		insinto /usr/share/policy
		newins "seccomp_filters/btdispatch-seccomp-${ARCH}.policy" btdispatch-seccomp.policy
		newins "seccomp_filters/newblued-seccomp-${ARCH}.policy" newblued-seccomp.policy
	else
		# Remove seccomp flags from minijail parameters.
		sed -i '/^env seccomp_flags=/s:=.*:="":' "${ED}"/etc/init/btdispatch.conf || die
		sed -i '/^env seccomp_flags=/s:=.*:="":' "${ED}"/etc/init/newblued.conf || die
	fi

	platform_fuzzer_install "${S}"/OWNERS "${OUT}"/bluetooth_parsedataintouuids_fuzzer
	platform_fuzzer_install "${S}"/OWNERS "${OUT}"/bluetooth_parsedataintoservicedata_fuzzer
	platform_fuzzer_install "${S}"/OWNERS "${OUT}"/bluetooth_parseeir_fuzzer
	platform_fuzzer_install "${S}"/OWNERS "${OUT}"/bluetooth_parsereportdescriptor_fuzzer
	platform_fuzzer_install "${S}"/OWNERS "${OUT}"/bluetooth_trimadapterfromobjectpath_fuzzer
	platform_fuzzer_install "${S}"/OWNERS "${OUT}"/bluetooth_trimdevicefromobjectpath_fuzzer
	platform_fuzzer_install "${S}"/OWNERS "${OUT}"/bluetooth_trimservicefromobjectpath_fuzzer
	platform_fuzzer_install "${S}"/OWNERS "${OUT}"/bluetooth_trimcharacteristicfromobjectpath_fuzzer
	platform_fuzzer_install "${S}"/OWNERS "${OUT}"/bluetooth_trimdescriptorfromobjectpath_fuzzer
}

platform_pkg_test() {
	platform_test "run" "${OUT}/bluetooth_test"
}
