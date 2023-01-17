# Copyright 2022 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="6a44797281a2337d8bf2120d8a7c4c6b9d65a2af"
CROS_WORKON_TREE=("6836462cc3ac7e9ff3ce4e355c68c389eb402bff" "ba5fe7197d7651faba2e881da633e3abcffe9313" "4dd86cd2749d067fc00e26145f612405ab7419fb" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
CROS_WORKON_INCREMENTAL_BUILD="1"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
# TODO(b/187784160): Avoid directly including headers from other packages.
CROS_WORKON_SUBTREE="common-mk arc/vm/data_migrator cryptohome .gn"

PLATFORM_SUBDIR="arc/vm/data_migrator"

inherit cros-workon platform user

DESCRIPTION="ARCVM /data migration tool."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/arc/vm/data_migrator"

LICENSE="BSD-Google"
KEYWORDS="*"

RDEPEND="
	chromeos-base/cryptohome:=
"

DEPEND="
	${RDEPEND}
	chromeos-base/system_api:=
"
pkg_preinst() {
	enewuser "arcvm_data_migrator"
	enewgroup "arcvm_data_migrator"
}

platform_pkg_test() {
	platform test_all
}
