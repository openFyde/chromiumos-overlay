# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="44c46742d7eaabcb38ef5abd36c8e27742f7613f"
CROS_WORKON_TREE=("20fecf8e8aefa548043f2cb501f222213c15929d" "1ae46991e39cca1b8e6c576bb70170b432ece239" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD="1"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk arc/apk-cache .gn"

PLATFORM_NATIVE_TEST="yes"
PLATFORM_SUBDIR="arc/apk-cache"

inherit cros-workon platform

DESCRIPTION="Maintains APK cache in ARC."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/arc/apk-cache"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="+seccomp"

RDEPEND="
	chromeos-base/minijail
	dev-db/sqlite:=
"

DEPEND="
	dev-db/sqlite:=
"

src_install() {
	platform_install
	platform_fuzzer_install "${S}"/OWNERS "${OUT}"/apk_cache_database_fuzzer \
		--comp 157100
}

platform_pkg_test() {
	platform test_all
}
