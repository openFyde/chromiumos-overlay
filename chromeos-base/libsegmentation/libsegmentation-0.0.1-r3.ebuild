# Copyright 2023 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="410f3d5e668f715073f98e01459b5bcffaf65ab8"
CROS_WORKON_TREE=("8fad85aa9518e1a0f04272ae9e077c4a4036297d" "477d762c6427ff15bf78dbc5b7246328a358cc99" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk libsegmentation .gn"

PLATFORM_SUBDIR="libsegmentation"

inherit cros-workon platform

DESCRIPTION="Library to get Chromium OS system properties"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/libsegmentation"

LICENSE="BSD-Google"
KEYWORDS="*"

platform_pkg_test() {
	platform test_all
}
