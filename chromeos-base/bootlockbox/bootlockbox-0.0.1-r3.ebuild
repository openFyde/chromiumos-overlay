# Copyright 2022 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="476f9abaac4e00d6f1519661a0ce4b424cc7e064"
CROS_WORKON_TREE=("bb46f20bc6d2f9e7fb1aa1178d1e47384440de9a" "ce61d742e551778e7bbcfceafae69d520c438e19" "17bdc3c664a4bad17dfdff0350af34faae44800f" "bfcaa22d5e5fc6da26723eee3290eda10ae47d20" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk cryptohome libhwsec libhwsec-foundation .gn"

PLATFORM_SUBDIR="cryptohome/bootlockbox"

inherit cros-workon platform user

DESCRIPTION="BootLockbox service for Chromium OS"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/cryptohome/bootlockbox/"
SRC_URI=""

LICENSE="BSD-Google"
SLOT="0/0"
KEYWORDS="*"
IUSE="fuzzer systemd test"

RDEPEND="
	!<chromeos-base/cryptohome-0.0.2
	chromeos-base/bootlockbox-client:=
	chromeos-base/libhwsec:=[test?]
	chromeos-base/minijail:=
	chromeos-base/system_api:=[fuzzer?]
	>=chromeos-base/metrics-0.0.1-r3152:=
	chromeos-base/tpm_manager:=
	dev-libs/openssl:=
	dev-libs/protobuf:=
"

DEPEND="${RDEPEND}"

src_install() {
	platform_src_install
}

pkg_preinst() {
	enewuser "bootlockboxd"
	enewgroup "bootlockboxd"
}

platform_pkg_test() {
	platform test_all
}
