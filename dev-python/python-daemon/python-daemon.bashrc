# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

cros_pre_src_prepare_patches() {
	epatch "${BASHRC_FILESDIR}"/${P}-docutils.patch
}
