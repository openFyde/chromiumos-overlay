# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=6

CROS_WORKON_COMMIT="f64c1749b81099c31822e6c99d229a1e250a8d5b"
CROS_WORKON_TREE=("11f584bb7dd3244e1eec145f7e377b32b68e8b3b" "4e849ce828d9a47db0ae8c5a8f41223a2028cdc2" "dc1506ef7c8cfd2c5ffd1809dac05596ec18773c")
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
SLOT="0"
KEYWORDS="*"

DEPEND="x11-libs/libdrm:="

src_install() {
	dolib.a "${OUT}"/librendernodehost.a
}
