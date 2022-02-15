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
	# HP USB-C Dock G5
	"c15a0df7386812781d1f376fe54729e64f69b2a8a6c4b580914d4f6740e4fcc3-HP-USBC_DOCK_G5-V1.0.13.0.cab"
)
SRC_URI="${FILENAMES[*]/#/${CROS_FWUPD_URL}/}"
LICENSE="LVFS-Vendor-Agreement-v1"

IUSE="+remote"

KEYWORDS="~*"

DEPEND=""
RDEPEND="sys-apps/fwupd"
