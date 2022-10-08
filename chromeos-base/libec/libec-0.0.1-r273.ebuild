# Copyright 2020 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="85b14a06205ad4309c718357829421bc4706d018"
CROS_WORKON_TREE=("bfd385199f68d1daa35195e75f5e51fb1215fdcb" "4b7854d72e018cacbb3455cf56f41cee31c70fc1" "d33645008156649c56e9f940456b7045f578fe8d" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
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
