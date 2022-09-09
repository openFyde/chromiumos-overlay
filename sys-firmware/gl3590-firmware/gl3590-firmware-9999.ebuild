# Copyright 2022 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# This ebuild only cares about its own FILESDIR and ebuild file, so it tracks
# the canonical empty project.
CROS_WORKON_PROJECT="chromiumos/infra/build/empty-project"
CROS_WORKON_LOCALNAME="../platform/empty-project"

inherit cros-workon cros-fwupd

DESCRIPTION="Installs eMMC firmware update files used by fwupd."
HOMEPAGE="https://fwupd.org/downloads"

KEYWORDS="~*"

FILENAMES=(
	"03e62779e44961cf3807ddc5c94c95e8bb7674998f072e86106a41c9707046c7-GenesysLogic_GL3590_64.14.cab"
	"c6fc09dab559e56a562bc90703c647a0e807b6565eb71237ab7154bac5c13c5f-GenesysLogic_GL3590_64.16.cab"
)
SRC_URI="${FILENAMES[*]/#/${CROS_FWUPD_URL}/}"
LICENSE="LVFS-Vendor-Agreement-v1"

DEPEND=""
RDEPEND="sys-apps/fwupd"
