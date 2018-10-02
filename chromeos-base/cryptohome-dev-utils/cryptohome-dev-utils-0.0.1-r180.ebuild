# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

CROS_WORKON_COMMIT="a457cc7a65c8cd23572df023e7eaf88e3f219a4e"
CROS_WORKON_TREE=("622fb2c6022cadd56f945e7964fc2352099a0337" "40bacde8a2d579992ed8703c3508932bd0c650a0" "af3ecc3924359691a89fb2dac19c12e197648f15" "dc1506ef7c8cfd2c5ffd1809dac05596ec18773c")
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
	chromeos-base/libscrypt
	chromeos-base/metrics
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
