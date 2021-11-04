# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_WORKON_COMMIT=("b9eca7a2bc8d57ed0722d2e7a95787fc5ac9d4e3" "6971b2f3155cf5dee48a990ff410df57f989fe5a" "48b28b8680caa31da7b5c4d3d44425a221b0c3ee")
CROS_WORKON_TREE=("dd5deba53d49ed330f1ab8e59f845daae76650c8" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "8046331b2b884d2ab80ac395e1befd78ae825b4c" "1e793181081ea50dec9407274b86bde3dfe50a71")
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
