# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="a4be31189d302c3163001b901bb73f89d1e9144a"
CROS_WORKON_TREE=("e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "e5bab9aeb635f426a5f77597edb46ad386ad0f7c" "80bb65ab125f7aaa2eddb0f06313cba045f954c6" "e5822571db2e92a58bc12dacc8e5042494372d19")
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="../platform2"
CROS_WORKON_SUBTREE=".gn camera/build camera/features/document_scanning common-mk"
CROS_WORKON_OUTOFTREE_BUILD="1"
CROS_WORKON_INCREMENTAL_BUILD="1"

PLATFORM_SUBDIR="camera/features/document_scanning"

inherit cros-workon platform

DESCRIPTION="Chrome OS camera Document Scanning test."

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"

RDEPEND="
	chromeos-base/libbrillo:=
	dev-cpp/gtest:=
	media-libs/cros-camera-document-scanning:="

DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_install() {
	platform_src_install
	dobin "${OUT}/document_scanner_perf_test"
}
