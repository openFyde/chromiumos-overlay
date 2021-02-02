# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

# Increment the "eclass bug workaround count" below when you change
# "cros-ec-release.eclass" to work around http://crbug.com/220902.
#
# eclass bug workaround count: 3

EAPI=7

CROS_WORKON_COMMIT=("197506c10838f9fad2cf9f74dd11e5ddac4cb2cc" "33f90599e3f0a5593a6975006d4323f63ea7c362" "3830fffbc5c5205bb8fb1b9f366fe44559923592")
CROS_WORKON_TREE=("6af4af6a53e1bd149f0e4dc8a390a736006af5f1" "8bc8f87033e6b9ced92bdf156f8f3b4585bd9549" "f3d026c790bd3d7121bb96ed2a4932360d698a73")
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
