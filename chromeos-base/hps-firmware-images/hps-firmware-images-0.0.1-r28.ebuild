# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="b0d3d4fb76a7de105c865cd2862a8751cb9c6c50"
CROS_WORKON_TREE="31d8ed0de99d8f5c4c34a34b8497901a9a0c6d38"
CROS_WORKON_PROJECT="chromiumos/platform/hps-firmware-images"
CROS_WORKON_LOCALNAME="platform/hps-firmware-images"

inherit cros-workon

DESCRIPTION="Chrome OS HPS firmware"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/hps-firmware-images/+/HEAD"

# For more details about the license, please refer to b/194344208#comment10.
LICENSE="BSD-Google BSD-2 Apache-2.0 MIT 0BSD BSD ISC"
KEYWORDS="*"

# before signing firmware files were installed from this source ebuild
RDEPEND="
	!<chromeos-base/hps-firmware-0.1.0-r296
"

src_install() {
	# Generate a single combined LICENSE file from all applicable license texts,
	# so that the Chrome OS license scanner can find it.
	cat <<-EOF > LICENSE
	HPS firmware source code is available under the Apache License 2.0.
	HPS firmware binaries also incorporate source code from several
	other projects under other licenses:
	EOF
	cat licenses/third-party/* >> LICENSE

	insinto "/usr/lib/firmware/hps"
	doins "${S}/firmware-signed/fpga_application.bin"
	doins "${S}/firmware-signed/fpga_bitstream.bin"
	doins "${S}/firmware-signed/mcu_stage1.bin"
}
