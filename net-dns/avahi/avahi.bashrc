# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

cros_pre_src_prepare_avahi_patches() {
	# TODO(benchan): Remove this patch after it's accepted by upstream.
	# See https://github.com/lathiat/avahi/pull/101.
	patch -p1 < "${BASHRC_FILESDIR}"/${P}-watch-cleanup.patch || die
}

cros_post_src_install_avahi_nls() {
	# Even if we build w/USE=-nls, avahi forces it back on when glib is
	# enabled.  Forcibly punt the translations since we never use them.
	rm -rf "${D}"/usr/share/locale
}
