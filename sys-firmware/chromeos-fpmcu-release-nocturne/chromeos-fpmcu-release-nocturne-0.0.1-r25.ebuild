# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

# Increment the "eclass bug workaround count" below when you change
# "cros-ec-release.eclass" to work around http://crbug.com/220902.
#
# eclass bug workaround count: 3

EAPI=7

CROS_WORKON_COMMIT=("abdb493fdaf8e9a0fb9b3117bc6d085faec961b2" "0702d48f0b2e8d2a34255c1b1cbd6bf99a6cbf52" "3830fffbc5c5205bb8fb1b9f366fe44559923592")
CROS_WORKON_TREE=("8153273126093f8370ddcbdc06a2a63e7832469b" "cc1a5821d0a092159a9c07f4d0289b0b39105a86" "f3d026c790bd3d7121bb96ed2a4932360d698a73")
FIRMWARE_EC_BOARD="nocturne_fp"
FIRMWARE_EC_RELEASE_REPLACE_RO="yes"

CROS_WORKON_PROJECT=(
	"chromiumos/platform/ec"
	"chromiumos/third_party/tpm2"
	"chromiumos/third_party/cryptoc"
)

CROS_WORKON_LOCALNAME=(
	"../platform/release-firmware/fpmcu-nocturne"
	"tpm2"
	"cryptoc"
)

CROS_WORKON_DESTDIR=(
	"${S}/platform/ec"
	"${S}/third_party/tpm2"
	"${S}/third_party/cryptoc"
)

CROS_WORKON_EGIT_BRANCH=(
	"firmware-fpmcu-dartmonkey-release"
	"master"
	"master"
)

inherit cros-workon cros-ec-release

HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/ec/+/master/README.md"
LICENSE="BSD-Google"
KEYWORDS="*"
