# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_WORKON_COMMIT="249b91d712897cc90fe57dd60d41154c68c1a094"
CROS_WORKON_TREE=("2c293b25dd09e3deae29a0dd7d637fbc1cc44597" "00ffd7cf775709a0e74a50142e0287a0bec5dbc5" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
	dev-libs/libevdev:=
	x11-libs/libxkbcommon:=
	x11-libs/libxcb:=
	x11-libs/pixman:=
	x11-libs/libdrm:=
	dev-libs/wayland:=
	|| (
		media-libs/mesa:=[gbm]
		media-libs/minigbm:=
	)
	!fuzzer? (
		x11-base/xwayland:=
	)
"

RDEPEND="
	!<chromeos-base/vm_guest_tools-0.0.2-r722
	${COMMON_DEPEND}
"

DEPEND="
	${COMMON_DEPEND}
	chromeos-base/perfetto
	dev-util/meson
	dev-util/ninja
"

src_install() {
	dobin "${OUT}"/sommelier

	# fuzzer_component_id is unknown/unlisted
	platform_fuzzer_install "${S}"/OWNERS "${OUT}"/sommelier_wayland_fuzzer
}

platform_pkg_test() {
	local tests=(
		sommelier_test
	)

	local test_bin
	for test_bin in "${tests[@]}"; do
		platform_test "run" "${OUT}/${test_bin}"
	done

	# Ensure the meson build script continues to work.
	if ! use x86 && ! use amd64 ; then
		elog "Skipping meson tests on non-x86 platform"
	else
		meson tmp_build_dir -Dgamepad=true -Dtracing=true -Dcommit_loop_fix=true \
				|| die "Failed to configure meson build"
		ninja -C tmp_build_dir || die "Failed to build sommelier with meson"
		[ -f tmp_build_dir/sommelier ] || die "Target 'sommelier' was not built by meson"
		ninja -C tmp_build_dir test || die "Tests failed"
	fi
}
