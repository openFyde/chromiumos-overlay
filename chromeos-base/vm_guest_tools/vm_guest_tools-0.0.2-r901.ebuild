# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="0dad9c31ffab93bc56b7c23c821a7842eb9e8b9c"
CROS_WORKON_TREE=("aa81756947ecfdd38b22f42eed8eeafa40431079" "32b34fb3a03edeb0a7b1c238a38100f810018860" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_SUBTREE="common-mk vm_tools .gn"

PLATFORM_SUBDIR="vm_tools"

inherit cros-go cros-workon platform user

DESCRIPTION="VM guest tools for Chrome OS"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/vm_tools"

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

	if use vm-containers; then
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
