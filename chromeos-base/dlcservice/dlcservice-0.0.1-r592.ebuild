# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="98e173dfff7282779e453d5694068880253faef3"
CROS_WORKON_TREE=("d9c21c3b0f24d480773fdba553eb9db4ee252072" "946b76c3e01ee5f5c1f42094c5ab62718ace8d99" "7f2d0530e333c2cfe5106b335fc2bff22ee483ca" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
# TODO(crbug.com/809389): Avoid #include-ing platform2 headers directly.
CROS_WORKON_SUBTREE="common-mk dlcservice metrics .gn"

PLATFORM_SUBDIR="dlcservice"

inherit cros-workon platform user

DESCRIPTION="A D-Bus service for Downloadable Content (DLC)"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/dlcservice/"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="fuzzer"

RDEPEND="
	chromeos-base/imageloader:=
	>=chromeos-base/metrics-0.0.1-r3152:=
	dev-libs/protobuf:="

DEPEND="${RDEPEND}
	chromeos-base/dlcservice-client:=
	chromeos-base/imageloader-client:=
	chromeos-base/system_api:=[fuzzer?]
	chromeos-base/session_manager-client:=
	chromeos-base/update_engine-client:="

src_install() {
	dosbin "${OUT}/dlcservice"
	# Technically we don't need the dlcservice_util in rootfs, but the QA team
	# will need this to test with sample-dlc.
	dobin "${OUT}/dlcservice_util"

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
	dobin "${S}/tools/dlctool"
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
