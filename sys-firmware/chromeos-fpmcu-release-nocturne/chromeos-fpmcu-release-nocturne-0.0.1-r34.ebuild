# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

# Increment the "eclass bug workaround count" below when you change
# "cros-ec-release.eclass" to work around http://crbug.com/220902.
#
# eclass bug workaround count: 3

EAPI=7

CROS_WORKON_COMMIT=("05118f2b62a054103ece11857c70583c28cab0c0" "6003a4d22289f86814155b867319e3611a8ebcbc" "3830fffbc5c5205bb8fb1b9f366fe44559923592")
CROS_WORKON_TREE=("5b4cb7ad6d5b36b1297b5a178d1604f0f4123226" "da49a94e30d1fd858e25756a2a433377acb7d4af" "f3d026c790bd3d7121bb96ed2a4932360d698a73")
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
