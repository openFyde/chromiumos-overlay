# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

cros_post_src_install_lddtree() {
	# Create a package we can use outside the SDK.
	# Only do this for the x86_64 system emulator as we use that in betty.
	/mnt/host/source/chromite/bin/lddtree \
		--copy-to "${D}/usr/libexec/qemu" \
		--libdir /lib \
		--bindir /bin \
		--generate-wrappers \
		"${D}"/usr/bin/qemu-system-x86_64 || die
	# No need to duplicate this in the package itself.
	dosym ../../../bin/qemu-system-x86_64 /usr/libexec/qemu/bin/qemu-system-x86_64.elf
	# QEMU searches for its bios files relative to itself.  Add a symlink so it
	# can find the installed bios files under /usr/share/qemu/.
	dosym ../../share/qemu /usr/libexec/qemu/pc-bios
}
