# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT="646339e066502e6acdc6caef29982d753c372e17"
CROS_WORKON_TREE=("c1d7f74d19fb8b195b14a17140c8594a3f5f37a9" "56e9c2f20c019def4a3de94a806556de56253a92")
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
