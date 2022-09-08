# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=7

CROS_WORKON_COMMIT=("c7155fb24a44895f4b829a79e8f94e95393076a6" "ae6a91860b4fa19db14167625fff6812c70c9349")
CROS_WORKON_TREE=("e96c7b05f7b481bedb62e65f6e9a177306f1b5b2" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "fc3cc5cfcfa6663292d202930bcb44ac50f7c555")
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
IUSE="biometrics_dev"

RDEPEND=""

DEPEND="${RDEPEND}"

src_install() {
	dolib.a "${OUT}"/libpinweaver.a

	insinto /usr/include/pinweaver
	doins eal/tpm_storage/pinweaver_eal_types.h
	doins pinweaver.h
	doins pinweaver_eal.h
	doins pinweaver_types.h
}
