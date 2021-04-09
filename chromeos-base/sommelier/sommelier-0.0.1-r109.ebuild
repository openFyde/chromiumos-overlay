# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_WORKON_COMMIT="e2c31be2c6dea118b5f77bc9ec1f4f470abdf6e2"
CROS_WORKON_TREE=("a54d2df3e8853d5a5f1e0854b36d8d850db3611e" "e626cc1ee45df96959dd791785b32eebe243df3c" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_DESTDIR="${S}/platform2"
CROS_WORKON_SUBTREE="common-mk vm_tools/sommelier .gn"

PLATFORM_SUBDIR="vm_tools/sommelier"

inherit cros-workon platform

DESCRIPTION="A Wayland compositor for use in CrOS VMs"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/vm_tools/sommelier"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="kvm_guest"

# This ebuild should only be used on VM guest boards.
REQUIRED_USE="kvm_guest"

COMMON_DEPEND="
	media-libs/mesa:=[gbm]
	x11-base/xwayland:=
	x11-libs/libxkbcommon:=
	x11-libs/pixman:=
"

RDEPEND="
	!<chromeos-base/vm_guest_tools-0.0.2-r722
	${COMMON_DEPEND}
"

DEPEND="
	${COMMON_DEPEND}
	dev-util/meson
	dev-util/ninja
"

src_install() {
	dobin "${OUT}"/sommelier
}

platform_pkg_test() {
	# TODO(hollingum): maybe sommelier would break less if it had any tests...
	local tests=(
	)

	local test_bin
	for test_bin in "${tests[@]}"; do
		platform_test "run" "${OUT}/${test_bin}"
	done

	# Ensure the meson build script continues to work.
	if ! use x86 && ! use amd64 ; then
		elog "Skipping meson tests on non-x86 platform"
	else
		meson tmp_build_dir || die "Failed to configure meson build"
		ninja -C tmp_build_dir || die "Failed to build sommelier with meson"
		[ -f tmp_build_dir/sommelier ] || die "Target 'sommelier' was not built by meson"
	fi
}
