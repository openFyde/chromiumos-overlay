# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

# Increment the "eclass bug workaround count" below when you change
# "cros-ec-release.eclass" to work around http://crbug.com/220902.
#
# eclass bug workaround count: 3

EAPI=7

CROS_WORKON_COMMIT=("abdb493fdaf8e9a0fb9b3117bc6d085faec961b2" "073dc25aa4dda42475a7a5a140399fc5db61b20f" "3c5ce9a1c631043476c0f52bad47f241680cc053")
CROS_WORKON_TREE=("8153273126093f8370ddcbdc06a2a63e7832469b" "f3618d301e99a5f52e91bb483844ffc9ec7c871e" "86f00f9caaf3655e9dd1cc01c05ac4662fa3dae5")
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
