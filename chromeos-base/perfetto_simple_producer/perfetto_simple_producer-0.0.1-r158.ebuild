# Copyright 2021 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="6549ea0eb91e124c3b9b75f77edc8e064b48813b"
CROS_WORKON_TREE=("7af090f4e3d17daa9e628424e4d774e246757618" "a902328aecda9ecdd865e246f3d1fb2317ec5518" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
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
