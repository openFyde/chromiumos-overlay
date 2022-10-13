# Copyright 2020 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="01611cc312c9b3acec36920032731ee8be032d07"
CROS_WORKON_TREE=("47d22a12e3e1c9b289e7c5dc26bc38d0f6324f66" "bb46f20bc6d2f9e7fb1aa1178d1e47384440de9a" "519533f5905e311e1f93fd184a2a9140a19e7038" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
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
