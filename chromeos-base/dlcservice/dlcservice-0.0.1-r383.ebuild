# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="228dac9861b4df02de291e270450bd4689715e0d"
CROS_WORKON_TREE=("f9717b507c2df65dc05165b9415ccd3154b01ecc" "291afae99580f88c60bf62b39d7d1822427ad55f" "7e189936f29d145c4191ea147e48256c92fac75d" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
	chromeos-base/metrics:=
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
