# Copyright 2018 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="91181e7f74a369f51c79b13422c2a08b8590e6f9"
CROS_WORKON_TREE=("e44d7e66ab4ccaab888a42ade972724af9621706" "1561f4e7d952717d6a2143fb58e3e2ca41ecf08e" "70d4a8ca946d6d0adf038d9afbdb57027e9887f7" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
# TODO(crbug.com/809389): Avoid #include-ing platform2 headers directly.
CROS_WORKON_SUBTREE="common-mk dlcservice metrics .gn"

PLATFORM_SUBDIR="dlcservice"

inherit cros-workon platform tmpfiles udev user

DESCRIPTION="A D-Bus service for Downloadable Content (DLC)"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/dlcservice/"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="
	fuzzer
	lvm_stateful_partition
"

RDEPEND="
	chromeos-base/imageloader:=
	lvm_stateful_partition? ( chromeos-base/lvmd:= )
	chromeos-base/minijail:=
	>=chromeos-base/metrics-0.0.1-r3152:=
	dev-libs/protobuf:="

DEPEND="${RDEPEND}
	chromeos-base/dlcservice-client:=
	chromeos-base/imageloader-client:=
	lvm_stateful_partition? ( chromeos-base/lvmd-client:= )
	chromeos-base/system_api:=[fuzzer?]
	chromeos-base/update_engine-client:=
	chromeos-base/vboot_reference:=
"

src_install() {
	platform_src_install

	# Install all the udev rules.
	udev_dorules "${FILESDIR}"/udev/*.rules

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
	enewgroup "disk-dlc" # For DLC logical volume management.
}
