# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

# Increment the "eclass bug workaround count" below when you change
# "cros-ec-release.eclass" to work around http://crbug.com/220902.
#
# eclass bug workaround count: 1

EAPI=7

CROS_WORKON_COMMIT=("22ad3ce20ae199e9177a1cc63d2d170fa63f9eea" "13e03ee133f7ee3764c5be8412649e203cdf7956" "1e2e9d7183f545eefd1a86a07b0ab6f91d837a6c")
CROS_WORKON_TREE=("2acece20af8307f916adbe1850384fe42f618e4f" "95a41e8434148a3cb8f7886090bae34ca5f3c9c7" "fdbc51bbd5a7ee9d532ea1aa30cf21e57ca199db")
FIRMWARE_EC_BOARD="bloonchipper"
FIRMWARE_EC_RELEASE_REPLACE_RO="yes"
FIRMWARE_EC_RELEASE_RO_VERSION="${FPMCU_FIRMWARE_BLOONCHIPPER_RO_VERSION}"

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
