# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

# Increment the "eclass bug workaround count" below when you change
# "cros-ec-release.eclass" to work around http://crbug.com/220902.
#
# eclass bug workaround count: 1

EAPI=7

CROS_WORKON_COMMIT=("427c530edeefb7026f8b2b31a44b5bdfd9369a16" "0be7f8dcc9bc3d082036fbab8c1caa67715a11f4" "51c319ff23b6e5d6b3d8deb539a063edffb24483")
CROS_WORKON_TREE=("544f4509d13de665a632eb8801fabe32e352458e" "a4c56d3bb4c4f359199854c87e06b4af06cf05ce" "5b25e42c84714218b06757c9d47399820bb64da5")
FIRMWARE_EC_BOARD="bloonchipper"

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

inherit cros-workon cros-ec-release

HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/ec/+/master/README.md"
LICENSE="BSD-Google"
KEYWORDS="*"
