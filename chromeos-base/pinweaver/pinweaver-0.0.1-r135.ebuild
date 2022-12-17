# Copyright 2021 The ChromiumOS Authors
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=7

CROS_WORKON_COMMIT=("569acd1eb0e5ee39f1e4b50921a0856c0b30f137" "1d4c5856b02e048c7cdeeeac1004249b459ae2fe")
CROS_WORKON_TREE=("0c3a30cd50ce72094fbd880f2d16d449139646a2" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6" "a52addfedb7943d6a8fbca8469c3f7aa4c934b6a")
inherit cros-constants

CROS_WORKON_LOCALNAME=(
	"platform2"
	"platform/pinweaver"
)
CROS_WORKON_PROJECT=(
	"chromiumos/platform2"
	"chromiumos/platform/pinweaver"
)
CROS_WORKON_OPTIONAL_CHECKOUT=(
	"true"
	"true"
)
CROS_WORKON_DESTDIR=(
	"${S}/platform2"
	"${S}/platform2/pinweaver"
)
# TODO(crbug.com/809389): Avoid directly including headers from other packages.
CROS_WORKON_SUBTREE=(
	"common-mk .gn"
	""
)
PLATFORM_SUBDIR="pinweaver"

inherit cros-workon platform

DESCRIPTION="PinWeaver code that can be used across implementation platforms."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/pinweaver/+/main/"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE="+biometrics_dev"

RDEPEND=""

DEPEND="${RDEPEND}"

src_install() {
	platform_src_install

	dolib.a "${OUT}"/libpinweaver.a

	insinto /usr/include/pinweaver
	doins eal/tpm_storage/pinweaver_eal_types.h
	doins pinweaver.h
	doins pinweaver_eal.h
	doins pinweaver_types.h
}
