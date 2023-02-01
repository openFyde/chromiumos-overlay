# Copyright 2018 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="7c2cf57a27ad5b5de19bda90ab5908add22d4863"
CROS_WORKON_TREE=("5a857fb996a67f6c9781b916ba2d6076e9dcd0a6" "235046655a0d95e1908108d3cdca41180fd53ba8" "1e1e4efab776c8e52de56c8d5089faf429051fdb" "b0e3863eb7f2ff9a3c1f75589366d018c639f9b5" "5642b00e57599f2e63af1c18afcefb3407d4b36e" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_INCREMENTAL_BUILD=1
# TODO(crbug.com/809389): Avoid directly including headers from other packages.
CROS_WORKON_SUBTREE="common-mk libhwsec libhwsec-foundation metrics u2fd .gn"

PLATFORM_SUBDIR="u2fd/g2f_tools"

inherit cros-workon platform

DESCRIPTION="G2F gnubby (U2F+GCSE) development and testing tools"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/u2fd"

LICENSE="BSD-Google"
SLOT="0/0"
KEYWORDS="*"

COMMON_DEPEND="
	chromeos-base/u2fd:=
	dev-libs/hidapi:=
"

RDEPEND="${COMMON_DEPEND}"

DEPEND="
	${COMMON_DEPEND}
	chromeos-base/chromeos-ec-headers:=
	chromeos-base/protofiles:=
	chromeos-base/system_api:=
"

platform_pkg_test() {
	platform test_all
}
