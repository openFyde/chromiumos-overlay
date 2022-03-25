# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT=("026d60aba8cb64ab3f1fc68005d2aa637cc9d35e" "dfc60765002d441b35d361f3e87547f024905763" "eee167fa829d108a5678624050425899b348a252")
CROS_WORKON_TREE=("20fecf8e8aefa548043f2cb501f222213c15929d" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "1a519760c0824042cf8dbf53f82dff26e2d34ea1" "dc25ed68a7d37cb190a28c01c84f8bb2e874bb47")
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
	""
	""
)
CROS_WORKON_INCREMENTAL_BUILD=1

PLATFORM_SUBDIR="aosp/frameworks/ml/chromeos/tests"

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

src_configure() {
	if use x86 || use amd64; then
		append-cppflags "-D_Float16=__fp16"
		append-cxxflags "-Xclang -fnative-half-type"
		append-cxxflags "-Xclang -fallow-half-arguments-and-returns"
	fi
	platform_src_configure
}

src_install() {
	platform_src_install

	dobin "${OUT}/cros_nnapi_vts_1_0"
	dobin "${OUT}/cros_nnapi_vts_1_1"
	dobin "${OUT}/cros_nnapi_vts_1_2"
	dobin "${OUT}/cros_nnapi_vts_1_3"
	dobin "${OUT}/cros_nnapi_cts"
}
