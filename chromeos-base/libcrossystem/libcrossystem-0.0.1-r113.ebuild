# Copyright 2022 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="1c77f6728f1b4aabd016a79bdccabeba93680f9b"
CROS_WORKON_TREE=("3f8a9a04e17758df936e248583cfb92fc484e24c" "4f69dce040c9bf4feac2c175de8d6d87f88df10e" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
CROS_WORKON_USE_VCSID="1"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk libcrossystem .gn"

PLATFORM_SUBDIR="libcrossystem"

inherit cros-workon platform

DESCRIPTION="Library to get Chromium OS system properties"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/libcrossystem"

LICENSE="BSD-Google"
KEYWORDS="*"

COMMON_DEPEND=""

RDEPEND="
	${COMMON_DEPEND}
	"

DEPEND="
	${COMMON_DEPEND}
	chromeos-base/vboot_reference:=
"

platform_pkg_test() {
	platform test_all
}
