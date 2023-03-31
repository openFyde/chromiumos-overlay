# Copyright 2017 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="e364b159e56f23ece2af994214187c650908d14f"
CROS_WORKON_TREE=("04da1711dfcf3e15f8ffb8bc59e4fc277481515b" "585af077146f2e4daaaec14eb5814cd8507e862c" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk secure_erase_file .gn"

PLATFORM_SUBDIR="secure_erase_file"

inherit cros-workon platform

DESCRIPTION="Secure file erasure for Chrome OS"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/secure_erase_file/"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE=""

DEPEND="
"

RDEPEND="
"
