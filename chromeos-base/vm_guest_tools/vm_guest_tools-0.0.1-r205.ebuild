# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT="d56870a879c806750037033b03ca7786247ecefd"
CROS_WORKON_TREE=("190c4cfe4984640ab62273e06456d51a30cfb725" "82ed2083ff58b5652e0230a3ebeb896e2eb7323c" "dc1506ef7c8cfd2c5ffd1809dac05596ec18773c")
CROS_GO_PACKAGES=(
	"chromiumos/vm_tools/tremplin_proto"
)

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
	media-libs/mesa[gbm]
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
	dobin "${OUT}"/notificationd
	dobin "${OUT}"/sommelier
	dobin "${OUT}"/virtwl_guest_proxy
	dobin "${OUT}"/vm_syslog
	dobin "${OUT}"/wayland_demo
	dobin "${OUT}"/x11_demo
	dosbin "${OUT}"/vshd

	into /
	newsbin "${OUT}"/maitred init

	dosym /run/resolv.conf /etc/resolv.conf

	CROS_GO_WORKSPACE="${OUT}/gen/go"
	cros-go_src_install
}

platform_pkg_test() {
	local tests=(
		garcon_desktop_file_test
		garcon_icon_index_file_test
		garcon_icon_finder_test
		garcon_mime_types_parser_test
		maitred_service_test
		maitred_syslog_test
		notificationd_test
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
