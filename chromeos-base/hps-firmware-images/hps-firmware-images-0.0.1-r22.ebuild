# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="1d53c29f5b05a318a6e8ba3b1cd6ac7b02e3c2aa"
CROS_WORKON_TREE="04c58873e02fd56b37dcd7bc3c2eb3df3387c750"
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
