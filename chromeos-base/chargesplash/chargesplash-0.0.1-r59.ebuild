# Copyright 2022 The ChromiumOS Authors
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI="7"

CROS_WORKON_COMMIT="01611cc312c9b3acec36920032731ee8be032d07"
CROS_WORKON_TREE=("bb46f20bc6d2f9e7fb1aa1178d1e47384440de9a" "b9bff5e76fc14e333b243bb22a1231b5cf26aef6" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
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
	dobin "${OUT}/chargesplash"
}

platform_pkg_test() {
	platform test_all
}
