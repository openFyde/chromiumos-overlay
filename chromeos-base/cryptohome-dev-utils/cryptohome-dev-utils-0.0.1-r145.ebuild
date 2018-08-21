# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

CROS_WORKON_COMMIT="dd0fe897461589844c9313444c6ee8d74a5fdf6f"
CROS_WORKON_TREE=("f4f32d7978699c3b7f803f658f33778abbb7aad2" "69a985c1c3c83316f797fc551f27fdc4634227f0" "f48ad2d5a76ed21ab0a9679c3a7f2496c49d4c77" "dc1506ef7c8cfd2c5ffd1809dac05596ec18773c")
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_DESTDIR="${S}/platform2"
CROS_WORKON_INCREMENTAL_BUILD=1
# TODO(crbug.com/809389): Avoid directly including headers from other packages.
CROS_WORKON_SUBTREE="common-mk cryptohome secure_erase_file .gn"

PLATFORM_SUBDIR="cryptohome"
PLATFORM_GYP_FILE="cryptohome-dev-utils.gyp"

inherit cros-workon platform

DESCRIPTION="Cryptohome developer and testing utilities for Chromium OS"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/cryptohome"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE="tpm tpm2"

REQUIRED_USE="tpm2? ( !tpm )"

RDEPEND="
	tpm? (
		app-crypt/trousers
	)
	tpm2? (
		chromeos-base/trunks
		chromeos-base/tpm_manager
		chromeos-base/attestation
	)
	chromeos-base/chaps
	chromeos-base/libbrillo:=
	chromeos-base/metrics
	chromeos-base/secure-erase-file
	dev-libs/openssl:=
	dev-libs/protobuf:=
	sys-fs/ecryptfs-utils
"

DEPEND="${RDEPEND}"

src_install() {
	dosbin "${OUT}"/cryptohome-tpm-live-test
}
