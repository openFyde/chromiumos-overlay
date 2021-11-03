# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="b31a9b728432f39e3e203a157099247d6bb82b33"
CROS_WORKON_TREE=("0d4ecaca2c9246b7d0f0fd9aa952cc67b495b596" "651dd9220b7c1753d9be19d970253a5b5efee7de" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD="1"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk perfetto_simple_producer .gn"

IUSE="cros-debug"

PLATFORM_SUBDIR="perfetto_simple_producer"

inherit cros-workon platform

DESCRIPTION="Simple Producer of Perfetto for Chromium OS."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/perfetto_simple_producer"

LICENSE="BSD-Google"
KEYWORDS="*"

DEPEND="
	chromeos-base/perfetto:="

src_install() {
	dobin "${OUT}"/perfetto_simple_producer
}
