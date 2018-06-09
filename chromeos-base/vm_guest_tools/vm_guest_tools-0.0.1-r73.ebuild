# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5
CROS_WORKON_COMMIT="3afa9f317dc587f02e4622ece4613203827aa8cd"
CROS_WORKON_TREE=("1d995a5f11b89f06713e6b213ea3f8741ace4008" "16ee3a42c8e449659a16c4b6fa3e4c759ddea427")
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_SUBTREE="common-mk vm_tools"

PLATFORM_SUBDIR="vm_tools"

inherit cros-workon platform user

DESCRIPTION="VM guest tools for Chrome OS"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/vm_tools"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE="kvm_guest"

# This ebuild should only be used on VM guest boards.
REQUIRED_USE="kvm_guest"

RDEPEND="
	!!chromeos-base/vm_tools
	chromeos-base/libbrillo
	chromeos-base/minijail
	dev-libs/grpc
	dev-libs/protobuf:=
	media-libs/minigbm
	x11-base/xwayland
	x11-libs/libxkbcommon
	x11-libs/pixman
"
DEPEND="
	${RDEPEND}
	>=sys-kernel/linux-headers-4.4-r16
"

src_configure() {
	platform_src_configure "vm_tools/sommelier/sommelier.gyp"
}

src_install() {
	dobin "${OUT}"/garcon
	dobin "${OUT}"/sommelier
	dobin "${OUT}"/virtwl_guest_proxy
	dobin "${OUT}"/vm_syslog
	dosbin "${OUT}"/vshd

	into /
	newsbin "${OUT}"/maitred init
}

platform_pkg_test() {
	local tests=(
		garcon_desktop_file_test
		garcon_icon_index_file_test
		garcon_icon_finder_test
		maitred_service_test
		maitred_syslog_test
	)

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
