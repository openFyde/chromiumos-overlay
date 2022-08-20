# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="16fcd93b78b5265da2dd9c01669e574602fc89e3"
CROS_WORKON_TREE=("702155bb86de2fd19e985a30ab9833bd73f715f7" "68361c6922909c829d679a3b5f79a5a64e977c35" "7b89f8fa5a7501d00fb10faaec5a875f0fb39fa0" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
