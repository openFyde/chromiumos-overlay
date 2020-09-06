# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="8c439c4d1fe4d4fa503b4feee7266c0d85e2f327"
CROS_WORKON_TREE=("e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "490b4dfd281aa5316e918f6195ce87d43c378bb3" "5868de62b85f7f824439fd5ba0fbee2418a2783c" "b6b10e03115551b69ba9e2502b15d5467adcd107")
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="platform2"
# TODO(crbug.com/809389): Remove libmems from this list.
CROS_WORKON_SUBTREE=".gn iioservice libmems common-mk"
CROS_WORKON_OUTOFTREE_BUILD="1"
CROS_WORKON_INCREMENTAL_BUILD="1"

PLATFORM_SUBDIR="iioservice/daemon"

inherit cros-workon platform user

DESCRIPTION="Chrome OS sensor HAL IPC util."

LICENSE="BSD-Google"
KEYWORDS="*"

RDEPEND="
	chromeos-base/libiioservice_ipc:=
	chromeos-base/libmems:=
"

DEPEND="${RDEPEND}
	chromeos-base/system_api:=
"

pkg_preinst() {
	enewuser "iioservice"
	enewgroup "iioservice"
}

src_install() {
	dosbin "${OUT}"/iioservice

	# Install upstart configuration.
	insinto /etc/init
	doins init/iioservice.conf
}

platform_pkg_test() {
	local tests=(
		iioservice_testrunner
	)

	local test_bin
	for test_bin in "${tests[@]}"; do
		platform_test "run" "${OUT}/${test_bin}"
	done
}
