# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

cros_pre_pkg_postinst_disable() {
	# pkg_postinst() in upstream package will install files to
	# /etc/runlevels which is masked. Don't let it do that.
	unset -f pkg_postinst
}
