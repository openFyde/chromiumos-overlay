# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="3a2710ce0cfb4eb6981fbe77788cef497bb40e27"
CROS_WORKON_TREE=("e27f1b4637c4d92b0c7b14963d2910ad6b0b631e" "c5fb1e5d38242b9580b77b814ef22b7e6d0da805" "4e4b38f52d224ba422e15e7c75a7ec41393928da" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
IUSE="+bluetooth_suspend_management fuzzer generated_cros_config seccomp unibuild"

RDEPEND="
	chromeos-base/chromeos-config-tools:=
	unibuild? (
		!generated_cros_config? ( chromeos-base/chromeos-config )
		generated_cros_config? ( chromeos-base/chromeos-config-bsp:= )
	)
	chromeos-base/newblue:=
	net-wireless/bluez:=
"

DEPEND="${RDEPEND}
	chromeos-base/system_api:=[fuzzer?]"

src_install() {
	dobin init/scripts/bluetooth-setup.sh
	dobin "${OUT}"/btdispatch

	insinto /etc/dbus-1/system.d
	doins dbus/org.chromium.Bluetooth.conf

	insinto /etc/init
	doins init/upstart/bluetooth-setup.conf
	doins init/upstart/btdispatch.conf

	if use seccomp; then
		# Install seccomp policy files.
		insinto /usr/share/policy
		newins "seccomp_filters/btdispatch-seccomp-${ARCH}.policy" btdispatch-seccomp.policy
	else
		# Remove seccomp flags from minijail parameters.
		sed -i '/^env seccomp_flags=/s:=.*:="":' "${ED}"/etc/init/btdispatch.conf || die
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
