# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT=("6bd73255679114f74ecf971677e2ccb71fc5fd3e" "1021ee62dfcc9ecc05fa255669e86e749f9d7581")
CROS_WORKON_TREE=("2117aff37f7d1324e283d78595a793c34f98ca7c" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "e6f123687608d892f84e1a917042b655c83d3272")
CROS_WORKON_PROJECT=(
	"chromiumos/platform2"
	"aosp/platform/frameworks/ml"
)
CROS_WORKON_REPO=(
	"${CROS_GIT_HOST_URL}"
	"${CROS_GIT_HOST_URL}"
)
CROS_WORKON_LOCALNAME=(
	"platform2"
	"aosp/frameworks/ml"
)
CROS_WORKON_DESTDIR=(
	"${S}/platform2"
	"${S}/platform2/aosp/frameworks/ml"
)
CROS_WORKON_SUBTREE=(
	"common-mk .gn"
	"nn"
)

PLATFORM_SUBDIR="aosp/frameworks/ml/nn"

inherit cros-workon platform

DESCRIPTION="Chrome OS port of the Android Neural Network API"
HOMEPAGE="https://developer.android.com/ndk/guides/neuralnetworks"

LICENSE="BSD-Google Apache-2.0"
KEYWORDS="*"
IUSE=""

RDEPEND="
	chromeos-base/nnapi
	dev-libs/openssl:=
	sci-libs/tensorflow:=
"

DEPEND="
	${RDEPEND}
"

platform_pkg_test() {
	local tests=(
		chromeos
	)

	local test_target
	for test_target in "${tests[@]}"; do
		platform_test "run" "${OUT}/${test_target}_testrunner"
	done
}
