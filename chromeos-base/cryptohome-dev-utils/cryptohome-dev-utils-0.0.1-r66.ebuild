# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

CROS_WORKON_COMMIT="dfbdc8be9b10b7000e2ce542a371c2fa26e22176"
CROS_WORKON_TREE=("32c5802f3fce5f474cfae5f70fb058b1df68675f" "7763bdf84ac2a57d80d9362ce9d425bb85111726" "2879d4e7ab8b8818fbd9c9eaf75e54739e7bb22f")
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_DESTDIR="${S}/platform2"
CROS_WORKON_INCREMENTAL_BUILD=1
# TODO(crbug.com/809389): Avoid directly including headers from other packages.
CROS_WORKON_SUBTREE="common-mk cryptohome secure_erase_file"

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
