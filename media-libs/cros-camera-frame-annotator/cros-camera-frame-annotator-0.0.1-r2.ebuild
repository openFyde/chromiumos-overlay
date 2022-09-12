# Copyright 2022 The ChromiumOS Authors.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="cc6c9af6ba9c780864ced7e7e50d81916f87b515"
CROS_WORKON_TREE=("e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "5fc34f384cd5fc6a13144a7f836f2371938bb8a6" "f386c5ad3b69b5be8dd06422610d7f81853224be" "c457b08fd133fa46cd7a5cd2f8b4c1a783ceca8a" "ef2ad081f7944c8c3323a3468f013e2024d389a3" "b5413a1de5fea67b73a33d2bda74fdcfa0fb8ed6" "8821bec7557652f636e7eed8ee7944b23b50b4b8" "905de1b1a650f3a518fda231b371365a4954e6f5" "bfb6ecc4da4dc2d7aafa35ed314e5d2fb8f2f8a6" "6c730fa6bc9c00d204b80c4944f1951b8f35a48e")
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="../platform2"
CROS_WORKON_SUBTREE=".gn camera/build camera/common camera/include camera/features camera/gpu camera/mojo chromeos-config common-mk iioservice/mojo"
CROS_WORKON_OUTOFTREE_BUILD="1"
CROS_WORKON_INCREMENTAL_BUILD="1"

PLATFORM_SUBDIR="camera/features/frame_annotator/libs"

inherit cros-workon platform

DESCRIPTION="ChromeOS Camera Frame Annotator Library"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"

BDEPEND="virtual/pkgconfig"

RDEPEND="
	media-libs/skia:=
	chromeos-base/cros-camera-libs:=
"
DEPEND="
	${RDEPEND}
"

src_configure() {
	cros_optimize_package_for_speed
	platform_src_configure
}

src_install() {
	platform_src_install

	dolib.so "${OUT}"/lib/libcros_camera_frame_annotator.so
}
