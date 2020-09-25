# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

# Increment the "eclass bug workaround count" below when you change
# "cros-ec-release.eclass" to work around http://crbug.com/220902.
#
# eclass bug workaround count: 3

EAPI=7

CROS_WORKON_COMMIT=("b47fb93f92cb6ac9e737f51ca229a8d12d533179" "0217366d293dc71f7873d0a879384c0336ebdd7b" "3c5ce9a1c631043476c0f52bad47f241680cc053")
CROS_WORKON_TREE=("8153273126093f8370ddcbdc06a2a63e7832469b" "8e2ebe98fade4195aac74d52d0647b116b0165c5" "86f00f9caaf3655e9dd1cc01c05ac4662fa3dae5")
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
