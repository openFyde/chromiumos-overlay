# Copyright 2022 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="1f66d37568dc0272ef95c5350ac2d323076bc25e"
CROS_WORKON_TREE=("ca7895485a50f354a0c396417657ff67fbbdf40f" "20935f9acf243f0a53d8d96daf2503e84d44979d" "d4c4fe03c50d64fce9a627711516d0832433c2d6" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
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
