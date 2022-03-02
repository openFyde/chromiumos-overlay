# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="a792205dedcf7a6d4e597a6be6d8fd203bfeda5a"
CROS_WORKON_TREE="89a88291bd7987cf22b9c8418b69465d5b47360d"
CROS_WORKON_PROJECT="chromiumos/platform/hps-firmware-images"
CROS_WORKON_LOCALNAME="platform/hps-firmware-images"

inherit cros-workon

DESCRIPTION="Chrome OS HPS firmware"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/hps-firmware-images/+/HEAD"

# For more details about the license, please refer to b/194344208#comment10.
LICENSE="BSD-Google BSD-2 Apache-2.0 MIT 0BSD BSD ISC"
KEYWORDS="*"

src_install() {
	# Generate a single combined LICENSE file from all applicable license texts,
	# so that the Chrome OS license scanner can find it.
	cat <<-EOF > LICENSE
	HPS firmware source code is available under the Apache License 2.0.
	HPS firmware binaries also incorporate source code from several
	other projects under other licenses:
	EOF
	cat licenses/third-party/* >> LICENSE

	dobin "${S}"/bin/*
}
