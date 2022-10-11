# Copyright 2019 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

# Increment the "eclass bug workaround count" below when you change
# "cros-ec-release.eclass" to work around https://issuetracker.google.com/201299127.
#
# eclass bug workaround count: 8

EAPI=7

CROS_WORKON_COMMIT=("c453fd704268ef72de871b0c5ac7a989de662334" "2de0a64491451f72c7ffe5eb92301f4da509d0ad" "11a97df4133f905bbdf9ddb48b5d56d617ec949b")
CROS_WORKON_TREE=("fcf6ce5810f9ff9e3c8cce434812dd75492269ed" "f6cadf087425f2c77af8879a7f83e722ab613a36" "cafc71cae4ef6b3e7e64648b257b3f0ca2300e1d")
FIRMWARE_EC_BOARD="nami_fp"
FIRMWARE_EC_RELEASE_REPLACE_RO="yes"

CROS_WORKON_PROJECT=(
	"chromiumos/platform/ec"
	"chromiumos/third_party/tpm2"
	"chromiumos/third_party/cryptoc"
)

CROS_WORKON_LOCALNAME=(
	"../platform/release-firmware/fpmcu-nami"
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
