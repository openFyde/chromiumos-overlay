# Copyright 2022 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="130ac2db842d5543b3480d120841840318895710"
CROS_WORKON_TREE=("6836462cc3ac7e9ff3ce4e355c68c389eb402bff" "8aa55b7709350dc79666f509c6f641b7536cf99e" "e125dde00aa762efcd2b10dbc6c677ff0af4b432" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
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
