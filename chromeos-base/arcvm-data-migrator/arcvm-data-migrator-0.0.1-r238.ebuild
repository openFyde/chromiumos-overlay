# Copyright 2022 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="bb9afe6773e6b4e0927003b9b85087f875eef03e"
CROS_WORKON_TREE=("017dc03acde851b56f342d16fdc94a5f332ff42e" "b0b4b8623c10ff1f5a822817f29d3cfc996a55c7" "c4cb7e29f301580b0eec869a3e5426f6a71744cc" "e1f223c8511c80222f764c8768942936a8de01e4" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
CROS_WORKON_INCREMENTAL_BUILD="1"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
# TODO(b/187784160): Avoid directly including headers from other packages.
CROS_WORKON_SUBTREE="common-mk arc/vm/data_migrator cryptohome metrics .gn"

PLATFORM_SUBDIR="arc/vm/data_migrator"

inherit cros-workon platform user

DESCRIPTION="ARCVM /data migration tool."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/arc/vm/data_migrator"

LICENSE="BSD-Google"
KEYWORDS="*"

RDEPEND="
	chromeos-base/cryptohome:=
	>=chromeos-base/metrics-0.0.1-r3152:=
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
