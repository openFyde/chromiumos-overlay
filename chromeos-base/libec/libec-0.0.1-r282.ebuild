# Copyright 2020 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="7ff3ed122ad4eb01b70cf24e68a529b1096281e4"
CROS_WORKON_TREE=("45c752998b9ddd46e79510171bb18dc29ed79005" "bb46f20bc6d2f9e7fb1aa1178d1e47384440de9a" "86c2ed387f2da7f0f3120b334fc913ff0e615516" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
CROS_WORKON_USE_VCSID="1"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="biod common-mk libec .gn"

PLATFORM_SUBDIR="libec"

inherit cros-workon platform

DESCRIPTION="Embedded Controller Library for Chromium OS"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/libec"

LICENSE="BSD-Google"
KEYWORDS="*"

COMMON_DEPEND=""

RDEPEND="
	${COMMON_DEPEND}
	"

DEPEND="
	${COMMON_DEPEND}
	chromeos-base/chromeos-ec-headers:=
	chromeos-base/power_manager-client:=
"

platform_pkg_test() {
	platform test_all
}
