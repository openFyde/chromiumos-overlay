# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

# Increment the "eclass bug workaround count" below when you change
# "cros-ec-release.eclass" to work around http://crbug.com/220902.
#
# eclass bug workaround count: 1

EAPI=7

CROS_WORKON_COMMIT=("31131080886b8d1e19360bf70091219ee06cd91a" "f4428141132ec85eb255a819fc5bdaea2303f6af" "e05bfa91102dd5137b4027b4f3405e041ffe2c32")
CROS_WORKON_TREE=("68d3fc6879fe662130bc27f25a03791284bf8f30" "4b0eaae00da0418755628097981bf4013f92a3a6" "1f42f6d549ba7b3f6bc5d67029984b113787ae0d")
FIRMWARE_EC_BOARD="dartmonkey"

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
