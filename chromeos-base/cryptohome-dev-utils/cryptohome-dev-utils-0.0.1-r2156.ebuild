# Copyright 2018 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="5b3ea69ae524f32217a9af72ff0d172ebecc4a8e"
CROS_WORKON_TREE=("ebcce78502266e81f55c63ade8f25b8888e2c103" "809f8039090aede8822e17625f91f6314c48be23" "104508898bd6312a5a9bba33aa0ec4c15b9a25f3" "008df207326041dd4a94c8afd1d528b42b4237eb" "0cbf638bdbdbacc203abd3bcb0d31c738f9fd9ed" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_DESTDIR="${S}/platform2"
CROS_WORKON_INCREMENTAL_BUILD=1
# TODO(crbug.com/809389): Avoid directly including headers from other packages.
CROS_WORKON_SUBTREE="common-mk cryptohome libhwsec libhwsec-foundation secure_erase_file .gn"

PLATFORM_SUBDIR="cryptohome/dev-utils"

inherit cros-workon platform

DESCRIPTION="Cryptohome developer and testing utilities for Chromium OS"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/cryptohome"

LICENSE="BSD-Google"
SLOT="0/0"
KEYWORDS="*"
IUSE="tpm tpm_dynamic tpm2"

REQUIRED_USE="
	tpm_dynamic? ( tpm tpm2 )
	!tpm_dynamic? ( ?? ( tpm tpm2 ) )
"

# TODO(b/230430190): Remove shill-client dependency after experiment ended.
COMMON_DEPEND="
	tpm? (
		app-crypt/trousers:=
	)
	tpm2? (
		chromeos-base/trunks:=
	)
	chromeos-base/attestation:=
	chromeos-base/biod_proxy:=
	chromeos-base/bootlockbox-client:=
	chromeos-base/cbor:=
	chromeos-base/chaps:=
	chromeos-base/chromeos-config-tools:=
	>=chromeos-base/libbrillo-0.0.1-r2089:=
	chromeos-base/libhwsec:=
	>=chromeos-base/metrics-0.0.1-r3152:=
	chromeos-base/shill-client:=
	chromeos-base/tpm_manager:=
	chromeos-base/secure-erase-file:=
	dev-libs/flatbuffers:=
	dev-libs/glib:=
	dev-libs/openssl:=
	dev-libs/protobuf:=
	sys-apps/keyutils:=
	sys-fs/e2fsprogs:=
	sys-fs/ecryptfs-utils:=
"

RDEPEND="${COMMON_DEPEND}"

DEPEND="${COMMON_DEPEND}
	chromeos-base/vboot_reference:=
"
