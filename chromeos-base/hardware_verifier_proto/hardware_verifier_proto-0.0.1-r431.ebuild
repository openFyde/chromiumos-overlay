# Copyright 2020 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="275d66618708a79567dbec7b6034d5d08e291bcc"
CROS_WORKON_TREE=("0c4b88db0ba1152616515efb0c6660853232e8d0" "38d7e8f3a67c14718619b826697df434baffdf3c" "9c1a122c121b06b7f48cf0852ac656d255a739c1" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
CROS_GO_PACKAGES=(
	"chromiumos/hardware_verifier/..."
)

CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk hardware_verifier metrics .gn"

PLATFORM_SUBDIR="hardware_verifier/proto"

inherit cros-workon cros-go platform

DESCRIPTION="Hardware Verifier go proto for Chrome OS"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/hardware_verifier/proto"

LICENSE="BSD-Google"
KEYWORDS="*"

DEPEND="
	>=chromeos-base/metrics-0.0.1-r3152:=
	chromeos-base/system_api:=
	chromeos-base/vboot_reference:=
	dev-go/protobuf
	dev-go/protobuf-legacy-api
"

src_unpack() {
	platform_src_unpack
	CROS_GO_WORKSPACE="${OUT}/gen/go"
}

src_install() {
	cros-go_src_install
}
