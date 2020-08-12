# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=7
CROS_WORKON_COMMIT="f80e5b66a301eb14eb7c36e9d6f4a1c3873f9833"
CROS_WORKON_TREE=("769fb4f49054e9865b1f33ae4e56510f00074285" "17f9c028acddc2e40fba081ac7e82e8b3929ae9d" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_SUBTREE="common-mk croslog .gn"

PLATFORM_SUBDIR="croslog"

inherit cros-workon platform

DESCRIPTION="Log viewer for Chromium OS"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/croslog"

LICENSE="BSD-Google"
SLOT="0/0"
KEYWORDS="*"
IUSE=""

src_install() {
	platform_install

	insinto /etc/init
	doins etc/log-bootid-on-boot.conf

	exeinto /usr/share/cros/init
	doexe scripts/upstart/*.sh
}

platform_pkg_test() {
	platform test_all
}

