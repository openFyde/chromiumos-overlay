# Copyright 2018 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="1c77f6728f1b4aabd016a79bdccabeba93680f9b"
CROS_WORKON_TREE=("fd7cc1c8d2d0bdcfbee7335c0b535ee09c0ca534" "3f8a9a04e17758df936e248583cfb92fc484e24c" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
CROS_WORKON_INCREMENTAL_BUILD="1"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="arc/adbd common-mk .gn"

PLATFORM_SUBDIR="arc/adbd"

inherit cros-workon platform

DESCRIPTION="Container to run Android's adbd proxy."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/arc/adbd"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="+seccomp fuzzer arcvm"

RDEPEND="
	chromeos-base/minijail
"

src_install() {
	platform_src_install

	# Install fuzzers.
	# fuzzer_component_id is unknown/unlisted
	platform_fuzzer_install "${S}"/OWNERS "${OUT}"/arc-adbd-setup-config-fs-fuzzer
	platform_fuzzer_install "${S}"/OWNERS "${OUT}"/arc-adbd-setup-function-fs-fuzzer
	platform_fuzzer_install "${S}"/OWNERS "${OUT}"/arc-adbd-create-pipe-fuzzer
}
