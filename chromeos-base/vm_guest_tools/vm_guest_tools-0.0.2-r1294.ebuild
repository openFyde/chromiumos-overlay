# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="01db1e94698ec091083a252bbff75a82e266b90c"
CROS_WORKON_TREE=("be0561582cec761c3be2d8ca3ac2b966901b7d58" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "7ef75a42aba67052842459f221271e681184cc89" "0865c9d3ea1e3df829430fe6bc25ecbc3bc865ca" "dbc0caa5a8069a51f3821099fd9e938ce98205d5" "5159f439e8516f904859190cfd0375b7a4d05db2" "9c1bb445b657a6e6e0f8cfd62b4b1a3e6c2eb976" "97190407ff6df6ae497a54e632369afdf09cd621" "e3c0f091b7ac5b77bad60486002908f4e3efdbbb" "49733aa1ca831c8f507f6c0eae190e74c4c188d3" "eb96cc6a31989d091d04dd3fe29628b360e3e438" "5b2d971fbeb4e9b96656113119005e6831f2317f" "b423643df4afaa0a936886bdc3d6b1749c0b6e7a" "889e63b35e958b34d6cf15f62b243d442f1bac83" "6a87e586432bf560a19a662dc6b9d3fa89daaf83" "81465f23987dd2c482006411430ef171e856c5fe" "a01dc69a1e1fa54805fe9b48ce5c278a7e70de0c")
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
