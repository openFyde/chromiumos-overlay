# Copyright 2018 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="f773967488f06a06bff49e8dffd4037ad5e89e96"
CROS_WORKON_TREE=("fdb9ece09dc742924f2694c7005ea7c06fee00d9" "0c4b88db0ba1152616515efb0c6660853232e8d0" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
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
