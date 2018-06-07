# Copyright (c) 2013 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="4"
CROS_WORKON_COMMIT="e36ca9f18aee4b496cae8b80c2265d494734f75b"
CROS_WORKON_TREE="e0037f64493912fa7931c73158c395feaf57a592"
CROS_WORKON_PROJECT="chromiumos/platform/touch_updater"
CROS_WORKON_OUTOFTREE_BUILD=1

inherit cros-workon user

DESCRIPTION="Touch firmware and config updater"
HOMEPAGE="http://www.chromium.org/"
SRC_URI=""

LICENSE="BSD"
SLOT="0"
KEYWORDS="*"
IUSE="input_devices_synaptics
	input_devices_wacom
	input_devices_st
	input_devices_weida
	input_devices_goodix
	input_devices_sis
"

RDEPEND="
	input_devices_synaptics? ( chromeos-base/rmi4utils )
	input_devices_wacom? ( chromeos-base/wacom_fw_flash )
	input_devices_st? ( chromeos-base/st_flash )
	input_devices_weida? ( chromeos-base/weida_wdt_util )
	input_devices_goodix? ( chromeos-base/gdix_hid_firmware_update )
	input_devices_sis? ( chromeos-base/sisConsoletool )
	sys-apps/mosys
"

pkg_preinst() {
	if use input_devices_sis; then
		enewgroup sisfwupdate
		enewuser sisfwupdate
	fi
}

src_install() {
	exeinto "/opt/google/touch/scripts"
	doexe scripts/*.sh

	if [ -d "policies/${ARCH}" ]; then
		insinto "/opt/google/touch/policies"
		doins policies/${ARCH}/*.policy
	fi
}
