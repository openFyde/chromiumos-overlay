# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT="2834bc6ae3c03ec6968dc27116528fe646c4d818"
CROS_WORKON_TREE=("34bcb6266df551e7744073b28ff1b6aa18023fe2" "868ee4ce5538b9f6cb245e65f6f55e6d7883c533")
CROS_GO_PACKAGES=(
	"chromiumos/vm_tools/tremplin_proto"
)

CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_SUBTREE="common-mk vm_tools"

PLATFORM_SUBDIR="vm_tools"

inherit cros-go cros-workon platform user

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
	dev-go/grpc
	dev-go/protobuf
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

	CROS_GO_WORKSPACE="${OUT}/gen/go"
	cros-go_src_install
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
