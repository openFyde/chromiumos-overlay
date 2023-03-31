# Copyright 2016 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
CROS_WORKON_COMMIT="e45a18d710d7f272f37451f09533820d78dd92a3"
CROS_WORKON_TREE=("79fac61039fd2754d03bcc2c4f0caad6c3f4ed72" "a3e2de3c2cdc6702011f5b3b1b2039cfd2868c7e" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_INCREMENTAL_BUILD="1"
CROS_WORKON_SUBTREE="common-mk st_flash .gn"

PLATFORM_SUBDIR="st_flash"

inherit cros-workon platform

DESCRIPTION="STM32 IAP firmware updater for Chrome OS touchpads"
HOMEPAGE=""

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE=""
