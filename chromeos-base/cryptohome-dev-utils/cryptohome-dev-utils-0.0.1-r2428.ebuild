# Copyright 2018 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="d814215e38b3bc21021ed6f77fb0c26ba33f9f79"
CROS_WORKON_TREE=("3f8a9a04e17758df936e248583cfb92fc484e24c" "a6e52ed024640715bea55a33f54db29bb7e1d0e7" "70184f9a70acdc66ffdd6f250b76ad7dc403868e" "c1195005f152ed453ed87250e60e2dfa9502a6c4" "585af077146f2e4daaaec14eb5814cd8507e862c" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
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
	chromeos-base/featured:=
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
