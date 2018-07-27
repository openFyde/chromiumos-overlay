# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT="ff06da0ea49ff9c0cd4820ad2cb0ec91d40bd3a4"
CROS_WORKON_TREE=("34bcb6266df551e7744073b28ff1b6aa18023fe2" "4b6b6d89b01757a86771f12344063f956604d08b")
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
