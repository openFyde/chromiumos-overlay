# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT="724e8fed97eb25bc7f3e2d5aeceb79a5e3d1c253"
CROS_WORKON_TREE=("564023743cbb0d3d970ae3aeaeb717e3c5e87e0a" "f5631408d9cd14d181f36b0df0e2de2bd6868b36" "dc1506ef7c8cfd2c5ffd1809dac05596ec18773c")
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_SUBTREE="common-mk hermes .gn"

PLATFORM_SUBDIR="hermes"

inherit cros-workon platform

DESCRIPTION="Chrome OS eSIM/EUICC integration"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/hermes"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_install() {
	dobin "${OUT}"/hermes
}

platform_pkg_test() {
	platform_test "run" "${OUT}/hermes_test"
}
