# Copyright 2019 The ChromiumOS Authors
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
	# Dell WD19/WD19DC/WD19TB/WD22TB4
	"a7ec6fb710d020ab2589e67935c83f507908ecce32ada5e8a773df02518efed6-DellDockFirmwareUpdateLinux_01.00.09.cab"
	# Lenovo MiniDock
	"9950c7162ef41c770bca803b5455bd7bd82c9820b4ca2075bdf5bce4ac91a895-Lenovo-Mini_Dock-2020-10-29-155326_release.cab"
	# Lenovo Powered Travel Hub Gen2
	"ebfda3c96543d6d7ad97a972344f4d34a14549c535095bfbb1860115a88e6ff6-Lenovo-TravalHub-2020-12-11-153442.cab"
	# Lenovo ThinkPad USB-C Dock Gen2
	"29835d73b07590db964d796e508058e512c55ff0ca2a75b9c8ac2ed1fe305de5-Lenovo-ThinkPad-USBCGen2Dock-PDFirmware-0.0.34.cab"
	"ac37f23af002e91df11094b08fd2e076cf9c8cb4f08930be8eefe35850097a60-Lenovo-ThinkPad-USBCGen2Dock-DP-Firmware-5.05.00.cab"
	"2e0bf8aaf9c63ca11cfe3444d032277c21ec0d678e5963123a8b33e5dcd37d99-Lenovo-ThinkPad-USBCGen2Dock-Firmware-49-0E-14.cab"
	"9a13f9fefa59ae42c06e9861dc20a0e53e35d471c6a1c05d6426a011b0fada30-Lenovo-ThinkPad-USBCGen2Dock-USBHUB-Firmware-0D23_7a216856-8a97-550c-882e-8233751c7cf2.cab"
	"f241ce8c26d83546d5bfd1d67b70b9324f32ea4790acebb2a5e7d5a071eaaa85-Lenovo-ThinkPad-USBCGen2Dock-USBHUBQ7-Firmware-0D24_4ec36768-1858-5e9b-9d35-40e6143c3cd4.cab"
	# HP Thunderbolt Dock G4
	"7239756ad0ad9c084f820c0a94de33b4e3160dbdb1dde97ea83a68c506c5f298-Thunderbolt_Dock_G4_V1.3.12.0.cab"
	# HP USB-C Dock G5
	"1675d5a0f18c148df2a8b28f80de602bc0a556ff36be9004fea8e302ddf75fc5-USBC_DOCK_G5_V1.0.15.0.cab"
	# EPOS Impact 230
	"65cf05e4319820957a5c8bb0dd4513eb2627f155f6887590093a31661b54137e-EPOSIMPACT230.cab"
	# EPOS Adapt 1x5
	"03c682914b80c2512b189619c7b265601c72590ddb501e5f81cf343356e24e63-EPOSADAPT1x5.cab"
	# EPOS Impact 260
	"2692910674e690f8a821329c5d1cc5bf7a0342853639510ff81f0b5d1a8f5d5c-EPOSIMPACT260.cab"
)
SRC_URI="${FILENAMES[*]/#/${CROS_FWUPD_URL}/}"
LICENSE="LVFS-Vendor-Agreement-v1"

IUSE="+remote"

KEYWORDS="~*"

DEPEND=""
RDEPEND="sys-apps/fwupd"
