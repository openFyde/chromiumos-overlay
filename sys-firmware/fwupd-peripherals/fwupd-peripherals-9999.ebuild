# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# This ebuild only cares about its own FILESDIR and ebuild file, so it tracks
# the canonical empty project.
CROS_WORKON_PROJECT="chromiumos/infra/build/empty-project"
CROS_WORKON_LOCALNAME="../platform/empty-project"

inherit cros-workon cros-fwupd

DESCRIPTION="Installs peripherals firmware update files used by fwupd."
HOMEPAGE="https://fwupd.org/lvfs/devices/"
FILENAMES=(
	# Dell WD19/WD19DC/WD19TB
	"4e3f12fc1901c05790ab17ff2223a79631477aa87979498874c4c262cfafc144-WD19FirmwareUpdateLinux_01.00.21.cab"
	# Lenovo MiniDock
	"9950c7162ef41c770bca803b5455bd7bd82c9820b4ca2075bdf5bce4ac91a895-Lenovo-Mini_Dock-2020-10-29-155326_release.cab"
	# Lenovo ThinkPad USB-C Dock Gen2
	"29835d73b07590db964d796e508058e512c55ff0ca2a75b9c8ac2ed1fe305de5-Lenovo-ThinkPad-USBCGen2Dock-PDFirmware-0.0.34.cab"
	"ac37f23af002e91df11094b08fd2e076cf9c8cb4f08930be8eefe35850097a60-Lenovo-ThinkPad-USBCGen2Dock-DP-Firmware-5.05.00.cab"
	"2e0bf8aaf9c63ca11cfe3444d032277c21ec0d678e5963123a8b33e5dcd37d99-Lenovo-ThinkPad-USBCGen2Dock-Firmware-49-0E-14.cab"
	"9a13f9fefa59ae42c06e9861dc20a0e53e35d471c6a1c05d6426a011b0fada30-Lenovo-ThinkPad-USBCGen2Dock-USBHUB-Firmware-0D23_7a216856-8a97-550c-882e-8233751c7cf2.cab"
	"f241ce8c26d83546d5bfd1d67b70b9324f32ea4790acebb2a5e7d5a071eaaa85-Lenovo-ThinkPad-USBCGen2Dock-USBHUBQ7-Firmware-0D24_4ec36768-1858-5e9b-9d35-40e6143c3cd4.cab"
	# HP USB-C Dock G5
	"c15a0df7386812781d1f376fe54729e64f69b2a8a6c4b580914d4f6740e4fcc3-HP-USBC_DOCK_G5-V1.0.13.0.cab"
)
SRC_URI="${FILENAMES[*]/#/${CROS_FWUPD_URL}/}"
LICENSE="LVFS-Vendor-Agreement-v1"

IUSE="+remote"

KEYWORDS="~*"

DEPEND=""
RDEPEND="sys-apps/fwupd"
