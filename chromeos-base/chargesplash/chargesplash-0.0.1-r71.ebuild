# Copyright 2022 The ChromiumOS Authors
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI="7"

CROS_WORKON_COMMIT="35a85995e8aac3d700502064a0649dd1449d3ab1"
CROS_WORKON_TREE=("c7c0905a6b2404597933022decab6f4c5011aaf7" "28ddddfd006c3287b0c41e16c77c50b1173cb6db" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_DESTDIR="${S}/platform2"
CROS_WORKON_SUBTREE="common-mk chargesplash .gn"

PLATFORM_SUBDIR="chargesplash"

inherit cros-workon platform

DESCRIPTION="Frecon-based charging indicator"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/chargesplash"

LICENSE="BSD-Google"
SLOT="0/0"
KEYWORDS="*"

DEPEND="
	chromeos-base/libec:=
"

RDEPEND="
	${DEPEND}
	sys-apps/frecon
"

src_install() {
	platform_src_install

	dobin "${OUT}/chargesplash"
}

platform_pkg_test() {
	platform test_all
}
