# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_WORKON_COMMIT=("5bbbe52a139486abcbd802b9bd3f6763dac479b3" "eeedc6c48c951fc0e97c6ce224aab1bf3cd6d930" "48b28b8680caa31da7b5c4d3d44425a221b0c3ee")
CROS_WORKON_TREE=("ef118ceb3e8ebcc8b8a4ae6577a71d7ad210a722" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "32144d57e1c40e7ef63687ece65497f75222ef0f" "1e793181081ea50dec9407274b86bde3dfe50a71")
CROS_WORKON_PROJECT=("chromiumos/platform2" "aosp/platform/system/bt" "aosp/platform/system/bt")
CROS_WORKON_LOCALNAME=("../platform2" "../aosp/system/bt/upstream" "../aosp/system/bt/bringup")
CROS_WORKON_DESTDIR=("${S}/platform2" "${S}/platform2/bt" "${S}/platform2/bt")
CROS_WORKON_SUBTREE=("common-mk .gn" "" "")
CROS_WORKON_OPTIONAL_CHECKOUT=(
	""
	"use !bt-bringup"
	"use bt-bringup"
)

PLATFORM_SUBDIR="bt"

inherit cros-workon platform

DESCRIPTION="Bluetooth Tools and System Daemons for Linux"
HOMEPAGE="https://android.googlesource.com/platform/system/bt/"

LICENSE="Apache-2.0"
KEYWORDS="*"
IUSE="bt-bringup"
REQUIRED_USE="?? ( bt-bringup )"

DEPEND="
	dev-libs/modp_b64:=
	dev-libs/tinyxml2:=
"

RDEPEND="${DEPEND}"

DOCS=( README.md )
