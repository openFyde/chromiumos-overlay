# Copyright 2018 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="44cef19e5c52e4e87df910767231761461abb171"
CROS_WORKON_TREE=("f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6" "3a939e262dbbb04bab2434b9e34a18e1f4cbda60" "107f4541e74e07711b2309e26c12bddec382b1c4" "0b0dd5bc473351b6560e9918ec0b086342282058" "0c4b88db0ba1152616515efb0c6660853232e8d0")
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_SUBTREE=".gn camera/build camera/tools camera/include common-mk"
CROS_WORKON_OUTOFTREE_BUILD="1"
CROS_WORKON_INCREMENTAL_BUILD="1"

PLATFORM_SUBDIR="camera/tools/cros_camera_tool"

inherit cros-camera cros-workon platform

DESCRIPTION="Chrome OS camera test utility."

LICENSE="BSD-Google"
KEYWORDS="*"

RDEPEND="chromeos-base/cros-camera-libs:="

BDEPEND="virtual/pkgconfig"

src_install() {
	platform_src_install
	dobin "${OUT}/cros-camera-tool"
}
