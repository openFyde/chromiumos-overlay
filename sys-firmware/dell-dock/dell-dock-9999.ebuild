# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# This ebuild only cares about its own FILESDIR and ebuild file, so it tracks
# the canonical empty project.
CROS_WORKON_PROJECT="chromiumos/infra/build/empty-project"
CROS_WORKON_LOCALNAME="../platform/empty-project"

inherit cros-workon cros-fwupd

DESCRIPTION="Installs Dell Dock firmware update files used by fwupd."
HOMEPAGE="https://support.dell.com"
FILENAMES=(
	"4e3f12fc1901c05790ab17ff2223a79631477aa87979498874c4c262cfafc144-WD19FirmwareUpdateLinux_01.00.21.cab"
)
SRC_URI="${FILENAMES[*]/#/${CROS_FWUPD_URL}/}"
LICENSE="LVFS-Vendor-Agreement-v1"

KEYWORDS="~*"

DEPEND=""
RDEPEND="sys-apps/fwupd"
