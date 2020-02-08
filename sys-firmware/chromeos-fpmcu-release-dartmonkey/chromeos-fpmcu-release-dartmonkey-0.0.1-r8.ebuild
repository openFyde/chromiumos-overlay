# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

# Increment the "eclass bug workaround count" below when you change
# "cros-ec-release.eclass" to work around http://crbug.com/220902.
#
# eclass bug workaround count: 1

EAPI=7

CROS_WORKON_COMMIT=("99b5e2c9852277cc5d828fc659b3da4d8fc88f9c" "a4b6290cd6253bbeaad508e18d933484ff6f1d30" "51c319ff23b6e5d6b3d8deb539a063edffb24483")
CROS_WORKON_TREE=("de24666c969f091c31d12557623a396b426a5991" "af8c38a147ac8f1b3e4c21212b5976bdb51c34aa" "5b25e42c84714218b06757c9d47399820bb64da5")
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

inherit cros-workon cros-ec-release

HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/ec/+/master/README.md"
LICENSE="BSD-Google"
KEYWORDS="*"
