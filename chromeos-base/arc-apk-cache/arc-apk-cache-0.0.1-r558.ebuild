# Copyright 2018 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="ee11aa653a6e53c49ede4de52ac6f2280f2ffd73"
CROS_WORKON_TREE=("ca7895485a50f354a0c396417657ff67fbbdf40f" "5b07d7eb59f3e34e300468470e2204ef2244d9f4" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
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
	platform_src_install
	platform_fuzzer_install "${S}"/OWNERS "${OUT}"/apk_cache_database_fuzzer \
		--comp 157100
}

platform_pkg_test() {
	platform test_all
}
