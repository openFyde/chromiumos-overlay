# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT="5447e99207e29db479a19d396082b6d2b21bf2b8"
CROS_WORKON_TREE=("13228e56ac75327ed92fe81d6a0ed4f5c11c2a6a" "72a92e3fdf34cd58f022cbed8467c2576d040dbb" "dc1506ef7c8cfd2c5ffd1809dac05596ec18773c")
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

RDEPEND="
	chromeos-base/libbrillo:=
	"

DEPEND="
	${RDEPEND}
	chromeos-base/google-lpa:=
	chromeos-base/system_api:=
	"

src_install() {
	dobin "${OUT}"/hermes
}

platform_pkg_test() {
	platform_test "run" "${OUT}/hermes_test"
}
