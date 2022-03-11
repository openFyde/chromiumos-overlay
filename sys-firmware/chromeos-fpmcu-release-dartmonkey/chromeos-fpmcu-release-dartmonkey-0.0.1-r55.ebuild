# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

# Increment the "eclass bug workaround count" below when you change
# "cros-ec-release.eclass" to work around http://crbug.com/220902.
#
# eclass bug workaround count: 5

EAPI=7

CROS_WORKON_COMMIT=("aaf8a96fb96428d951b6176266e7ae6d203f22b2" "a77bf0779e1005c9fd840955193ac7257d67bc05" "92221d4688ed01cc361f01d650b82bf7e28078b2")
CROS_WORKON_TREE=("b4b1f3d2b3ab2ef8dde93032e5cc5d3d1c00a76f" "f64a48b91fc35d5760bca966436e0effc9e5cacb" "2aeca3cffd0e69db866b5623819ecd5bf8db1232")
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
