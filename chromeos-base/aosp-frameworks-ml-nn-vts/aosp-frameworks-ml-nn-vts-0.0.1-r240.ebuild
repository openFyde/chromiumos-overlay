# Copyright 2020 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT=("ac53c223b182819813ca5195fe8f9729e6e9466f" "9a35b91efc215fca3dbbdda3e4a3511e6ba78a62" "c1a2213d4dd7f89103213a881c852ebaf4e806af")
CROS_WORKON_TREE=("d12eaa6a060046041408b6cf0c2444c7da2bce2b" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6" "202e1663abd7a2cd2303f37e49fa041491ad790a" "941247a6ea5f4906ed073e5679a09891c50369df")
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
	# This warning is triggered in tensorflow.
	# See this Tensorflow PR for a fix:
	# https://github.com/tensorflow/tensorflow/pull/59040
	append-flags "-Wno-unused-but-set-variable"
	platform_src_configure
}

src_install() {
	platform_src_install

	dobin "${OUT}/cros_nnapi_vts_1_0"
	dobin "${OUT}/cros_nnapi_vts_1_1"
	dobin "${OUT}/cros_nnapi_vts_1_2"
	dobin "${OUT}/cros_nnapi_vts_1_3"
	dobin "${OUT}/cros_nnapi_vts_aidl"
	dobin "${OUT}/cros_nnapi_cts"
}
