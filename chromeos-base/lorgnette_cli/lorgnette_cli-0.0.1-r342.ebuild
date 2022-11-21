# Copyright 2020 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="7a088d53621117880bc35bfb7164361c5cf225ad"
CROS_WORKON_TREE=("ebcce78502266e81f55c63ade8f25b8888e2c103" "6c86f4e3541d13ba2a576a9d16e463bfd9661112" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_DESTDIR="${S}/platform2"
CROS_WORKON_SUBTREE="common-mk lorgnette .gn"

PLATFORM_SUBDIR="lorgnette"

inherit cros-workon platform

DESCRIPTION="Command line interface to scanning service for Chromium OS"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/lorgnette"

LICENSE="BSD-Google"
KEYWORDS="*"
SLOT="0/0"

RDEPEND="
	chromeos-base/lorgnette
"

src_install() {
	dobin "${OUT}"/lorgnette_cli
}
