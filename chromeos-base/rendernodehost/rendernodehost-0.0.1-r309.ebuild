# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=7

CROS_WORKON_COMMIT="89d3c0078a4dabc9e83b2e6d0273d6f2e2a53908"
CROS_WORKON_TREE=("f063c143da4054868aadc5be54cc3a45415a698e" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD="1"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk rendernodehost .gn"

PLATFORM_SUBDIR="rendernodehost"
WANT_LIBCHROME="no"

inherit cros-workon platform

DESCRIPTION="host service for render node forwarding"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/rendernodehost/"

LICENSE="BSD-Google"
KEYWORDS="*"

DEPEND="x11-libs/libdrm:="

src_install() {
	dolib.a "${OUT}"/librendernodehost.a
}
