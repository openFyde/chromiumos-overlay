# Copyright 2021 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="5cf6734c0a1e5dea7177fddb7653308505486bb5"
CROS_WORKON_TREE=("684de7632fb3bf23e07149db10c51780f7a80c39" "a902328aecda9ecdd865e246f3d1fb2317ec5518" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
CROS_WORKON_INCREMENTAL_BUILD="1"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk perfetto_simple_producer .gn"

IUSE="cros-debug"

PLATFORM_SUBDIR="perfetto_simple_producer"

inherit cros-workon platform

DESCRIPTION="Simple Producer of Perfetto for Chromium OS."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/perfetto_simple_producer"

LICENSE="BSD-Google"
KEYWORDS="*"

DEPEND="
	chromeos-base/perfetto:="

src_install() {
	dobin "${OUT}"/perfetto_simple_producer
}
