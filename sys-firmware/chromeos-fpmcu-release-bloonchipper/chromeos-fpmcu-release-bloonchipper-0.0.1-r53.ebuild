# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

# Increment the "eclass bug workaround count" below when you change
# "cros-ec-release.eclass" to work around http://crbug.com/220902.
#
# eclass bug workaround count: 4

EAPI=7

CROS_WORKON_COMMIT=("8244caf6ab8aa27ce2ddcf87f7b728e139315a27" "2149ae0304029034c65eed0e73b63194550e639a" "3830fffbc5c5205bb8fb1b9f366fe44559923592")
CROS_WORKON_TREE=("c4670a89fd145069e051f702847d1c0d4e310e90" "612b6a5c8233d074f7c63de6228c3c69f9c9d7e5" "f3d026c790bd3d7121bb96ed2a4932360d698a73")
FIRMWARE_EC_BOARD="bloonchipper"
FIRMWARE_EC_RELEASE_REPLACE_RO="yes"

CROS_WORKON_PROJECT=(
	"chromiumos/platform/ec"
	"chromiumos/third_party/tpm2"
	"chromiumos/third_party/cryptoc"
)

CROS_WORKON_LOCALNAME=(
	"../platform/release-firmware/fpmcu-bloonchipper"
	"tpm2"
	"cryptoc"
)

CROS_WORKON_DESTDIR=(
	"${S}/platform/ec"
	"${S}/third_party/tpm2"
	"${S}/third_party/cryptoc"
)

CROS_WORKON_EGIT_BRANCH=(
	"firmware-fpmcu-bloonchipper-release"
	"master"
	"master"
)

inherit cros-workon cros-ec-release

HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/ec/+/master/README.md"
LICENSE="BSD-Google"
KEYWORDS="*"
