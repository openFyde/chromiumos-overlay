# Copyright (c) 2013 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
CROS_WORKON_COMMIT="dea0a6324f58e13c1c0b23ea33626f5211675a6f"
CROS_WORKON_TREE=("968c62566a03aa7f1c2b5f60de51ab46d948a9b1" "7637c40bd3d13727126e5c821568f962c89eb83f")
CROS_WORKON_PROJECT="chromiumos/platform/touch_updater"
CROS_WORKON_SUBTREE="policies scripts"
CROS_WORKON_OUTOFTREE_BUILD=1

inherit cros-workon user

DESCRIPTION="Touch firmware and config updater"
HOMEPAGE="https://www.chromium.org/chromium-os"
SRC_URI=""

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE="
	input_devices_synaptics
	input_devices_wacom
	input_devices_etphidiap
	input_devices_st
	input_devices_st_touchscreen
	input_devices_weida
	input_devices_goodix
	input_devices_sis
	input_devices_pixart
	input_devices_g2touch
	input_devices_cirque
	input_devices_elan_i2chid
"

# Third party firmware updaters usually belong in sys-apps/.  If you just
# checked in a new one to chromeos-base/, please move it to sys-apps/ before
# adding it as a dependency here.
RDEPEND="
	chromeos-base/chromeos-touch-common
	input_devices_synaptics? ( chromeos-base/rmi4utils )
	input_devices_wacom? ( chromeos-base/wacom_fw_flash )
	input_devices_etphidiap? ( chromeos-base/chromeos-touch-etphidiap )
	input_devices_st? ( chromeos-base/st_flash )
	input_devices_st_touchscreen? ( chromeos-base/chromeos-touch-stupdate )
	input_devices_weida? ( chromeos-base/weida_wdt_util )
	input_devices_goodix? ( chromeos-base/gdix_hid_firmware_update )
	input_devices_sis? ( chromeos-base/sisConsoletool )
	input_devices_pixart? ( chromeos-base/pixart_tpfwup )
	input_devices_g2touch? ( chromeos-base/g2update_tool )
	input_devices_cirque? ( chromeos-base/cirque_fw_update )
	input_devices_elan_i2chid? ( chromeos-base/elan_i2chid_tools )
"

pkg_preinst() {
	if use input_devices_elan_i2chid; then
		enewgroup fwupdate-hidraw
		enewuser fwupdate-hidraw
	fi
	if use input_devices_sis; then
		enewgroup sisfwupdate
		enewuser sisfwupdate
	fi
	if use input_devices_pixart; then
		enewgroup pixfwupdate
		enewuser pixfwupdate
	fi
	if use input_devices_g2touch; then
		enewgroup g2touch
		enewuser g2touch
	fi
	if use input_devices_goodix; then
		enewgroup goodixfwupdate
		enewuser goodixfwupdate
	fi
	if use input_devices_cirque; then
		enewgroup cirque
		enewuser cirque
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
