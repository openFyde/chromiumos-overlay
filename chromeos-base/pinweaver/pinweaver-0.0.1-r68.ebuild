# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=7

CROS_WORKON_COMMIT=("73d7ada41175960869d962832228a1524acb36c5" "cb73fa7ecf332e8f04a9ae411c851ca9e0fff41a")
CROS_WORKON_TREE=("1127da40f25ab9f6f6d1c708ffc1308fbfff5f0e" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "2b4b267f0aeb1d51383a5742d6eb36af509e61f2")
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
