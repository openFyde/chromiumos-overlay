# Copyright 2022 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="109370dc4c6a8396728472816b156e91473d1787"
CROS_WORKON_TREE=("b9c8b8315a832ea4cfd3cb10367bc58e9a3ecb2a" "f79aecf8c807cf056efc1d2cb1758e40e8ac9703" "249d45ae093a250c805ae1595a2b1a8cb83bca13" "a2002e5b021a481c966a494642397c400fe65c93" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
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
