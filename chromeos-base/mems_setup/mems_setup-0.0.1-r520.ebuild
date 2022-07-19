# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="9ee9b6c607d6ffefd1fa79709080a8a29ca77735"
CROS_WORKON_TREE=("89089130f6bfed5a958ea1add13c9b55e9258be8" "657430c315ca70db10634d724d1800faca686404" "174e8d198304e8f5b847d6126dd6e3c7ab61ca10" "90f8db356759fb627ffd13e6b35b3aac5cff5a22" "6ed97df8defff98402f77ccced581e5862729960" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
	chromeos-base/libmems:=
	net-libs/libiio:=
	dev-libs/re2:=
"

RDEPEND="${COMMON_DEPEND}"

DEPEND="${COMMON_DEPEND}
	chromeos-base/system_api:="

src_install() {
	udev_dorules 99-mems_setup.rules
	dosbin "${OUT}"/mems_setup
	if use iioservice; then
		dosbin "${OUT}"/mems_remove
	fi

	# Install fuzzers
	local fuzzer_component_id="811602"
	insinto /usr/libexec/fuzzers
	for fuzzer in "${OUT}"/*_fuzzer; do
		platform_fuzzer_install "${S}"/OWNERS "${fuzzer}" \
				--comp "${fuzzer_component_id}"
	done
}

platform_pkg_test() {
	local tests=(
		mems_setup_testrunner
	)

	local test_bin
	for test_bin in "${tests[@]}"; do
		platform_test "run" "${OUT}/${test_bin}"
	done
}
