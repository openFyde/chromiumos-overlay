# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# This ebuild only cares about its own FILESDIR and ebuild file, so it tracks
# the canonical empty project.
CROS_WORKON_PROJECT="chromiumos/infra/build/empty-project"
CROS_WORKON_LOCALNAME="../platform/empty-project"

inherit cros-workon cros-fwupd

DESCRIPTION="Installs firmware update files used by fwupd."
HOMEPAGE="https://fwupd.org/downloads"

KEYWORDS="~*"

FILENAMES=(
	"06998fa5a9590b7ed0f90ad679ba48a27feba097095ae084e830e5106767d29a-Lenovo-ThinkPad-USBCGen2Dock-PDFirmware-0.0.34.cab"
	"d619a3c051e33df53094e274fbb672bdfa50d19d950ec337de36a68fe682fe18-Lenovo-ThinkPad-USBCGen2Dock-DP-Firmware-5.05.00.cab"
	"a5c8f0883f6089b780a25490b53eb8d5d6ba8a1d109ce44f18bd2b2ef3ffe315-Lenovo-ThinkPad-USBCGen2Dock-Firmware-49-0E-14.cab"
	"fbed8f8eee1e125a47a627724065e36ef8d7d0342c8d03fdba60616c4de3554e-Lenovo-ThinkPad-USBCGen2Dock-USBHUB-Firmware-0D23_7a216856-8a97-550c-882e-8233751c7cf2.cab"
	"d72204e110613bfacd65ca8e8783bf7f07272f4dfdb785cf1bd1c94b83ac5d33-Lenovo-ThinkPad-USBCGen2Dock-USBHUBQ7-Firmware-0D24_4ec36768-1858-5e9b-9d35-40e6143c3cd4.cab"
)
SRC_URI="${FILENAMES[*]/#/${CROS_FWUPD_URL}/}"
LICENSE="LVFS-Vendor-Agreement-v1"

DEPEND=""
RDEPEND="sys-apps/fwupd"
