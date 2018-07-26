# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT="121247a09b239f95d68a88661e309525b1b000fa"
CROS_WORKON_TREE=("bfef723cca347c05f3efa2e6e343d2ee5e693cc2" "d3e2f810d45899f52b65ba535cc870011c144f5b")
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_SUBTREE="common-mk hermes"

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
