# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="78a5ec877cc747d6e58455bed2a5f18a0483e99e"
CROS_WORKON_TREE=("6eabf6c16a6c482fcc6c234aa5f1e36293a9b92e" "c7df4baab3de9609134bd9255a3cdd97efdbf89e" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk dlcservice .gn"

PLATFORM_SUBDIR="dlcservice"

inherit cros-workon platform user

DESCRIPTION="A D-Bus service for Downloadable Content (DLC)"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/dlcservice/"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="fuzzer"

RDEPEND="
	chromeos-base/imageloader:=
	dev-libs/protobuf:="

DEPEND="${RDEPEND}
	chromeos-base/dlcservice-client:=
	chromeos-base/imageloader-client:=
	chromeos-base/system_api:=[fuzzer?]
	chromeos-base/session_manager-client:=
	chromeos-base/update_engine-client:="

src_install() {
	dosbin "${OUT}/dlcservice"

	# Seccomp policy files.
	insinto /usr/share/policy
	newins seccomp/dlcservice-seccomp-${ARCH}.policy \
		dlcservice-seccomp.policy

	# Upstart configuration
	insinto /etc/init
	doins dlcservice.conf

	# D-Bus configuration
	insinto /etc/dbus-1/system.d
	doins org.chromium.DlcService.conf

	platform_fuzzer_install "${S}"/OWNERS "${OUT}"/dlcservice_boot_device_fuzzer
	platform_fuzzer_install "${S}"/OWNERS "${OUT}"/dlcservice_boot_slot_fuzzer

	into /usr/local
	dobin "${OUT}/dlcservice_util"
}

platform_pkg_test() {
	platform_test "run" "${OUT}/dlcservice_tests"
	platform_fuzzer_test "${OUT}"/dlcservice_boot_device_fuzzer
	platform_fuzzer_test "${OUT}"/dlcservice_boot_slot_fuzzer
}

pkg_preinst() {
	enewuser "dlcservice"
	enewgroup "dlcservice"
}
