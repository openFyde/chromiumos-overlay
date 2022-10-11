# Copyright 2020 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="45e668cf9e8e475db429e8a951a44fd0c9de4c5c"
CROS_WORKON_TREE=("47d22a12e3e1c9b289e7c5dc26bc38d0f6324f66" "4b7854d72e018cacbb3455cf56f41cee31c70fc1" "a826d57cfaf4199ef89dd6ec6af300662fcbc31b" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
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
