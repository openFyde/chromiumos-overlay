# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="40aa2beead5a8d49f0a42c4097d0fc126d5f0272"
CROS_WORKON_TREE="0f91549bad008d3d02bf9b77e4774e3eff2c52df"
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

	# install into /firmware as part of signing process
	insinto "/firmware/hps"
	doins "${S}/firmware-bin/fpga_application.bin"

	# install into rootfs
	insinto "/usr/lib/firmware/hps"
	doins "${S}/firmware-bin/fpga_application.bin"

	dobin "${S}"/bin/*
}
