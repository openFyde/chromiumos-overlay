# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

# Increment the "eclass bug workaround count" below when you change
# "cros-ec-release.eclass" to work around http://crbug.com/220902.
#
# eclass bug workaround count: 5

EAPI=7

CROS_WORKON_COMMIT=("eecc138183ae7ef8545e9871ff5e6c5c41862dcc" "b9f81dd4fd067bcbda3dfec1716126c5d095df14" "92221d4688ed01cc361f01d650b82bf7e28078b2")
CROS_WORKON_TREE=("cc86e13c5ceccafd485c6aaba4ede227c01b0f16" "5eee531dcabf0f42bd4dfbfbee3727d5b2ab8c5f" "2aeca3cffd0e69db866b5623819ecd5bf8db1232")
FIRMWARE_EC_BOARD="dartmonkey"
FIRMWARE_EC_RELEASE_REPLACE_RO="yes"

CROS_WORKON_PROJECT=(
	"chromiumos/platform/ec"
	"chromiumos/third_party/tpm2"
	"chromiumos/third_party/cryptoc"
)

CROS_WORKON_LOCALNAME=(
	"../platform/release-firmware/fpmcu-dartmonkey"
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
