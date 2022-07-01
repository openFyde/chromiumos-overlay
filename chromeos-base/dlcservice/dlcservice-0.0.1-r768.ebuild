# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="919e4173733b8880496b873211cd25c1909c67cf"
CROS_WORKON_TREE=("1127da40f25ab9f6f6d1c708ffc1308fbfff5f0e" "995edbf5cdd4a296e623c5ddf59fd82a4af0fb2b" "b3d40dd8b9633e85d00396246f41d742729a1b8b" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
# TODO(crbug.com/809389): Avoid #include-ing platform2 headers directly.
CROS_WORKON_SUBTREE="common-mk dlcservice metrics .gn"

PLATFORM_SUBDIR="dlcservice"

inherit cros-workon platform tmpfiles user

DESCRIPTION="A D-Bus service for Downloadable Content (DLC)"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/dlcservice/"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="fuzzer"

RDEPEND="
	chromeos-base/imageloader:=
	chromeos-base/minijail:=
	>=chromeos-base/metrics-0.0.1-r3152:=
	dev-libs/protobuf:="

DEPEND="${RDEPEND}
	chromeos-base/dlcservice-client:=
	chromeos-base/imageloader-client:=
	chromeos-base/system_api:=[fuzzer?]
	chromeos-base/session_manager-client:=
	chromeos-base/update_engine-client:=
	chromeos-base/vboot_reference:=
"

src_install() {
	dosbin "${OUT}/dlcservice"
	# Technically we don't need the dlcservice_util in rootfs, but the QA team
	# will need this to test with sample-dlc.
	dobin "${OUT}/dlcservice_util"

	# Seccomp policy files.
	insinto /usr/share/policy
	newins "seccomp/dlcservice-seccomp-${ARCH}.policy" \
		dlcservice-seccomp.policy

	# Upstart configuration
	insinto /etc/init
	doins dlcservice.conf

	# Tmpfiles.d configuration
	dotmpfiles tmpfiles.d/*.conf

	# D-Bus configuration
	insinto /etc/dbus-1/system.d
	doins org.chromium.DlcService.conf

	local fuzzer_component_id="908242"
	platform_fuzzer_install "${S}"/OWNERS "${OUT}"/dlcservice_boot_device_fuzzer \
		--comp "${fuzzer_component_id}"
	platform_fuzzer_install "${S}"/OWNERS "${OUT}"/dlcservice_boot_slot_fuzzer \
		--comp "${fuzzer_component_id}"

	into /usr/local
	dobin "${S}/tools/dlctool"
	dobin "${OUT}/dlcverify"
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
