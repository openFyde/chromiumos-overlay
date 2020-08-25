# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="b19724e757f3e322222ba317309e04305824c4ba"
CROS_WORKON_TREE=("1c07dc76ec4881aeccc6c6151786dc26bf5f73c0" "be2ce461c9c702736c6774db15b15fbb7a5a1edf" "e5d3b93967ab0491498bc90862f9bee73883fea8" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
SLOT="0/0"
KEYWORDS="*"
IUSE="tpm tpm2"

REQUIRED_USE="tpm2? ( !tpm )"

COMMON_DEPEND="
	tpm? (
		app-crypt/trousers:=
	)
	tpm2? (
		chromeos-base/trunks:=
	)
	chromeos-base/attestation:=
	chromeos-base/biod_proxy:=
	chromeos-base/chaps:=
	chromeos-base/libscrypt:=
	>=chromeos-base/metrics-0.0.1-r3152:=
	chromeos-base/tpm_manager:=
	chromeos-base/secure-erase-file:=
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

src_install() {
	dosbin "${OUT}"/cryptohome-tpm-live-test
}
