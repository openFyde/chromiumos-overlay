# Copyright 2020 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="aee62015501b5cd861221714f392415261445e90"
CROS_WORKON_TREE=("d12eaa6a060046041408b6cf0c2444c7da2bce2b" "38d7e8f3a67c14718619b826697df434baffdf3c" "7f496168bcd30526ff9d96c34c665b62d825d39f" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
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
	platform_src_install

	cros-go_src_install
}
