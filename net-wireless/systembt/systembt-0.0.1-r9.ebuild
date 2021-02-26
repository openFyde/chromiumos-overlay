# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_WORKON_COMMIT=("9a2de0d377fdae131802e2c260721d2203d78009" "f6f9b9cebea2f60f9eaed5c08863f96cfc06d789" "658dcfe6cebb6f6c8c557c64fbc1707506b55058")
CROS_WORKON_TREE=("eaed4f3b0a8201ef3951bf1960728885ff99e772" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "e37faa2ad0fe92ad136ba4f327d45c1f39d9f45f" "41cf03235a04bb9ef7fb1cb8a105f3627fa7200d")
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
