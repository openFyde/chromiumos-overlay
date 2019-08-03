# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

CROS_WORKON_COMMIT="ca9e4b3e06d7e306777e23c7cf34d8ef2dc6a94f"
CROS_WORKON_TREE=("fb04314ba38f1b698a2ef2ac7178c9dffddfad70" "e211e4c9c5a32f5855a9939a764bee622817b179" "f27e9581dc578f9a83beacea11f5e9208ac3da24" "dc1506ef7c8cfd2c5ffd1809dac05596ec18773c")
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_DESTDIR="${S}/platform2"
CROS_WORKON_INCREMENTAL_BUILD=1
# TODO(crbug.com/809389): Avoid directly including headers from other packages.
CROS_WORKON_SUBTREE="common-mk cryptohome secure_erase_file .gn"

PLATFORM_SUBDIR="cryptohome/dev-utils"

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
	)
	chromeos-base/attestation
	chromeos-base/chaps
	chromeos-base/libbrillo:=
	chromeos-base/libscrypt
	chromeos-base/metrics
	chromeos-base/tpm_manager
	chromeos-base/secure-erase-file
	dev-libs/glib
	dev-libs/openssl:=
	dev-libs/protobuf:=
	sys-apps/keyutils
	sys-fs/e2fsprogs
	sys-fs/ecryptfs-utils
"

DEPEND="${RDEPEND}
	chromeos-base/vboot_reference
"

src_install() {
	dosbin "${OUT}"/cryptohome-tpm-live-test
}
