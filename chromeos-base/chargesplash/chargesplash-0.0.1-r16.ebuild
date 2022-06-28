# Copyright 2022 The ChromiumOS Authors.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI="7"

CROS_WORKON_COMMIT="1007e36b0e85b85b2140e91cb52ae9041b6df40f"
CROS_WORKON_TREE=("455da79bcff0fd8f44fbae5ad5e1d23e5ffd09fd" "83e2bdd8b74ac9fdb0c801679693d2bb0745064c" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
