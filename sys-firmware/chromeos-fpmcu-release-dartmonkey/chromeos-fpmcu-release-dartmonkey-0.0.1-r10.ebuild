# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

# Increment the "eclass bug workaround count" below when you change
# "cros-ec-release.eclass" to work around http://crbug.com/220902.
#
# eclass bug workaround count: 1

EAPI=7

CROS_WORKON_COMMIT=("99b5e2c9852277cc5d828fc659b3da4d8fc88f9c" "0be7f8dcc9bc3d082036fbab8c1caa67715a11f4" "1e2e9d7183f545eefd1a86a07b0ab6f91d837a6c")
CROS_WORKON_TREE=("de24666c969f091c31d12557623a396b426a5991" "a4c56d3bb4c4f359199854c87e06b4af06cf05ce" "fdbc51bbd5a7ee9d532ea1aa30cf21e57ca199db")
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
