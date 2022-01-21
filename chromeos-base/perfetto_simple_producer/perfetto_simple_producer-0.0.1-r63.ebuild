# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="a4be31189d302c3163001b901bb73f89d1e9144a"
CROS_WORKON_TREE=("e5822571db2e92a58bc12dacc8e5042494372d19" "b123dc919b5e4526b749e4ed09467143fa1fb5b5" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
