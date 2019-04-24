# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=6

CROS_WORKON_COMMIT="c5e129fb04bd33feb66f15cbcea3b816b1805d69"
CROS_WORKON_TREE=("abb168d9ecda9d00ce3e63c48d60028b32492066" "4e849ce828d9a47db0ae8c5a8f41223a2028cdc2" "dc1506ef7c8cfd2c5ffd1809dac05596ec18773c")
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
