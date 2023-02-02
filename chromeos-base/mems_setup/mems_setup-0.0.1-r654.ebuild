# Copyright 2019 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="bfe0c5c5d9e9585e676510b1ad8cc169c8c99dde"
CROS_WORKON_TREE=("5a857fb996a67f6c9781b916ba2d6076e9dcd0a6" "1f278221a140da65dbcc43dc504b10807efbde8c" "f14f92bf1c88a5f2e511eda39d7ba3a5b0240648" "4922d539997d859b3f417f55df28baa27aaf135a" "9edcaccb998f9f1dac82dd862beddc2491e8ab68" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
CROS_WORKON_INCREMENTAL_BUILD="1"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
# TODO(crbug.com/809389): Remove libmems from this list.
CROS_WORKON_SUBTREE="common-mk chromeos-config iioservice mems_setup libmems .gn"

PLATFORM_SUBDIR="mems_setup"

inherit cros-workon cros-unibuild platform udev

DESCRIPTION="MEMS Setup for Chromium OS."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/mems_setup"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="fuzzer iioservice"

COMMON_DEPEND="
	chromeos-base/chromeos-config-tools:=
	chromeos-base/libmems:=
	net-libs/libiio:=
	dev-libs/re2:=
"

RDEPEND="${COMMON_DEPEND}"

DEPEND="${COMMON_DEPEND}
	chromeos-base/system_api:="

src_install() {
	udev_dorules 99-mems_setup.rules
	platform_src_install

	# Install fuzzers
	local fuzzer_component_id="811602"
	insinto /usr/libexec/fuzzers
	for fuzzer in "${OUT}"/*_fuzzer; do
		platform_fuzzer_install "${S}"/OWNERS "${fuzzer}" \
				--comp "${fuzzer_component_id}"
	done
}

platform_pkg_test() {
	platform test_all
}
