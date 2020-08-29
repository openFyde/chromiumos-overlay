# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=7

CROS_WORKON_COMMIT="fda7723bb7a45184ab59d6f6ec0eed96d1264477"
CROS_WORKON_TREE=("b6b10e03115551b69ba9e2502b15d5467adcd107" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD="1"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk rendernodehost .gn"

PLATFORM_SUBDIR="rendernodehost"
WANT_LIBCHROME="no"

inherit cros-workon platform

DESCRIPTION="host service for render node forwarding"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/rendernodehost/"

LICENSE="BSD-Google"
KEYWORDS="*"

DEPEND="x11-libs/libdrm:="

src_install() {
	dolib.a "${OUT}"/librendernodehost.a
}
