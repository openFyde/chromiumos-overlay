# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT=("b0b08d1503d9a3b70db8a93202648c790d3328a5" "a69a9e160ff4db6cd8971d30d023aae1379a5c9a" "fd0a01eb09dcc34f1a42e5c0f6ebf0f384fd9abd")
CROS_WORKON_TREE=("82ffc96fb6e8d49ae4f8b8988124d565af3be61f" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "df22d4e62ef9f8c14cc0d07b7a815fa851f90f50" "7a08574830b90bb538e281ba8c2240d2826fefb9")
inherit cros-constants

CROS_WORKON_PROJECT=(
	"chromiumos/platform2"
	"aosp/platform/frameworks/ml"
	"aosp/platform/hardware/interfaces/neuralnetworks"
)
CROS_WORKON_REPO=(
	"${CROS_GIT_HOST_URL}"
	"${CROS_GIT_HOST_URL}"
	"${CROS_GIT_HOST_URL}"
)
CROS_WORKON_EGIT_BRANCH=(
	"main"
	"master"
	"master"
)
CROS_WORKON_LOCALNAME=(
	"platform2"
	"aosp/frameworks/ml"
	"aosp/hardware/interfaces/neuralnetworks"
)
CROS_WORKON_DESTDIR=(
	"${S}/platform2"
	"${S}/platform2/aosp/frameworks/ml"
	"${S}/platform2/aosp/hardware/interfaces/neuralnetworks"
)
CROS_WORKON_SUBTREE=(
	"common-mk .gn"
	"nn"
	""
)

PLATFORM_SUBDIR="aosp/frameworks/ml/nn/chromeos/tests"

inherit cros-workon platform flag-o-matic

DESCRIPTION="HAL / Driver Vendor and Compatability Test Tools for NNAPI"
HOMEPAGE="https://developer.android.com/ndk/guides/neuralnetworks"

LICENSE="BSD-Google Apache-2.0"
KEYWORDS="*"

RDEPEND="
	chromeos-base/aosp-frameworks-ml-nn:=
"

DEPEND="
	${RDEPEND}
"

cros-debug-add-NDEBUG() {
	# Don't set NDEBUG, overriding from cros-debug eclass.
	# If this is set, tests will fail and is also explicitly checked in
	# runtime/test/RequireDebug.cpp
	use cros-debug || echo "Not doing append-cppflags -NDEBUG";
}

src_configure() {
	if use x86 || use amd64; then
		append-cppflags "-D_Float16=__fp16"
		append-cxxflags "-Xclang -fnative-half-type"
		append-cxxflags "-Xclang -fallow-half-arguments-and-returns"
	fi
	platform_src_configure
}

src_install() {
	dobin "${OUT}/cros_nnapi_vts_1_0"
	dobin "${OUT}/cros_nnapi_vts_1_1"
	dobin "${OUT}/cros_nnapi_vts_1_2"
	dobin "${OUT}/cros_nnapi_vts_1_3"
	dobin "${OUT}/cros_nnapi_cts"
}
