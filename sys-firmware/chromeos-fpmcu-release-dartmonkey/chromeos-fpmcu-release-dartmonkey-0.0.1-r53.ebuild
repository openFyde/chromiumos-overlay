# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

# Increment the "eclass bug workaround count" below when you change
# "cros-ec-release.eclass" to work around http://crbug.com/220902.
#
# eclass bug workaround count: 5

EAPI=7

CROS_WORKON_COMMIT=("aedc4fc907139dc5689f424c80cc37d6750b7404" "0524768f7820f827b0b2c8d74fba8d038166364c" "92221d4688ed01cc361f01d650b82bf7e28078b2")
CROS_WORKON_TREE=("4a1d19df8407a704c99cbb0ab4a6b0e6dce590f2" "774719ed97ff3783a0e21cb191459ff627cf3616" "2aeca3cffd0e69db866b5623819ecd5bf8db1232")
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
