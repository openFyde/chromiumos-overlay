# Copyright 2017 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="0de64c22de751c4889507873c87928cebc1e27f9"
CROS_WORKON_TREE=("9706471f3befaf4968d37632c5fd733272ed2ec9" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6" "a26b0252ca4dd8384cc9ff4aec931dda6a1587c9" "2377aa9e152063b8a262181ff78384406b96b3b5" "d007cc50043f4cd109280ce1f0b38bfc851da338" "f368627960e9d37dd0154fe8655e3370bd2bba38" "518856ea09f70bf711e21884189dae26db6d43d3" "0c5a113933f1222bcbe43f22d86e947ce021ba47" "e2203ce3d67ef0be28234212ca484c240c9c4d67" "3dafeb94269e3bf5935c4d530a911b92b3debc1a" "9fb5abbc2a962f174fc1616ca571f523b41ce68a" "bd7a0511ef1962468aea43b0a40d5b458319c527" "b43e886293a2377f871de47ee78cf83c596cdf4d" "53d7146a8355184359434857b66bdadeb40b66a1" "107dd616fa74fa465f6546dc508304410e1a5d3f" "81465f23987dd2c482006411430ef171e856c5fe" "a01dc69a1e1fa54805fe9b48ce5c278a7e70de0c")
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_INCREMENTAL_BUILD=1

PLATFORM2_PATHS=(
	common-mk
	.gn

	vm_tools/BUILD.gn
	vm_tools/guest
	vm_tools/common

	vm_tools/demos
	vm_tools/garcon
	vm_tools/guest_service_failure_notifier
	vm_tools/maitred
	vm_tools/notificationd
	vm_tools/sommelier
	vm_tools/syslog
	vm_tools/upgrade_container
	vm_tools/virtwl_guest_proxy
	vm_tools/vsh

	# Required by the fuzzer
	vm_tools/OWNERS
	vm_tools/testdata
)
CROS_WORKON_SUBTREE="${PLATFORM2_PATHS[*]}"

PLATFORM_SUBDIR="vm_tools"

inherit cros-go cros-workon platform user

DESCRIPTION="VM guest tools for Chrome OS"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/vm_tools"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="kvm_guest vm-containers fuzzer vm_borealis"

# This ebuild should only be used on VM guest boards.
REQUIRED_USE="kvm_guest"

COMMON_DEPEND="
	!!chromeos-base/vm_tools
	chromeos-base/minijail:=
	net-libs/grpc:=
	dev-libs/protobuf:=
	dev-go/protobuf-legacy-api:=
"

RDEPEND="
	${COMMON_DEPEND}
	vm-containers? (
		chromeos-base/crash-reporter
	)
	!fuzzer? (
		chromeos-base/sommelier
	)
"

DEPEND="
	${COMMON_DEPEND}
	dev-go/grpc:=
	dev-go/protobuf:=
	sys-kernel/linux-headers:=
	chromeos-base/vm_protos:=
"

src_install() {
	platform_src_install

	dobin "${OUT}"/vm_syslog
	dosbin "${OUT}"/vshd

	if use vm-containers || use vm_borealis; then
		dobin "${OUT}"/garcon
	fi
	if use vm-containers; then
		dobin "${OUT}"/guest_service_failure_notifier
		dobin "${OUT}"/notificationd
		dobin "${OUT}"/upgrade_container
		dobin "${OUT}"/virtwl_guest_proxy
		dobin "${OUT}"/wayland_demo
		dobin "${OUT}"/x11_demo
	fi

	# fuzzer_component_id is unknown/unlisted
	platform_fuzzer_install "${S}"/OWNERS "${OUT}"/garcon_desktop_file_fuzzer \
		--dict "${S}"/testdata/garcon_desktop_file_fuzzer.dict
	platform_fuzzer_install "${S}"/OWNERS "${OUT}"/garcon_icon_index_file_fuzzer \
		--dict "${S}"/testdata/garcon_icon_index_file_fuzzer.dict
	platform_fuzzer_install "${S}"/OWNERS "${OUT}"/garcon_ini_parse_util_fuzzer
	platform_fuzzer_install "${S}"/OWNERS "${OUT}"/garcon_mime_types_parser_fuzzer

	into /
	newsbin "${OUT}"/maitred init

	# Create a folder for process configs to be launched at VM startup.
	dodir /etc/maitred/

	use fuzzer || dosym /run/resolv.conf /etc/resolv.conf

	CROS_GO_WORKSPACE="${OUT}/gen/go"
	cros-go_src_install
}

platform_pkg_test() {
	local tests=(
		maitred_init_test
		maitred_service_test
		maitred_syslog_test
	)

	local container_tests=(
		garcon_desktop_file_test
		garcon_icon_index_file_test
		garcon_icon_finder_test
		garcon_mime_types_parser_test
		notificationd_test
	)

	if use vm-containers || use vm_borealis; then
		tests+=( "${container_tests[@]}" )
	fi

	local test_bin
	for test_bin in "${tests[@]}"; do
		platform_test "run" "${OUT}/${test_bin}"
	done
}

pkg_preinst() {
	# We need the syslog user and group for both host and guest builds.
	enewuser syslog
	enewgroup syslog
}
