# Copyright 2022 The ChromiumOS Authors.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI="7"

CROS_WORKON_COMMIT="55fe26b58c0a6458f452b79307b61ad101e911ab"
CROS_WORKON_TREE=("02bfff6bead7011dd0b16a3393e99a677d8e4e0e" "83e2bdd8b74ac9fdb0c801679693d2bb0745064c" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
