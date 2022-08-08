# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=7

CROS_WORKON_COMMIT=("298ef2f73e7e0aae4ebc813439473b7301b2c251" "8a276a6be1f23d6ae6bca3c23118e06bb5aee32b")
CROS_WORKON_TREE=("81608e81e7a1a6aacd7096a66fd44588c1d5ece9" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "518b6770e17380fdd9bb0bdf3feb91d4180094dc")
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
IUSE=""

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
