# Copyright (c) 2013 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

cros_pre_src_prepare_brltty_config() {
	epatch "${FILESDIR}"/${P}-fix-build.patch
}

cros_post_src_install_brltty_config() {
	insinto /etc
	doins "${FILESDIR}"/brltty.conf
	exeinto $(get_udevdir)
	doexe "${FILESDIR}"/brltty
}
