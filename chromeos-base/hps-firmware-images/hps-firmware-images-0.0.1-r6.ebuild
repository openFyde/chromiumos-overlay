# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="6f75bc7d9933a2364d1911e07a720666e2803516"
CROS_WORKON_TREE="be2b4e132ba6e74b239e536f6e131b69dd411793"
inherit cros-workon

CROS_WORKON_PROJECT="chromiumos/platform/hps-firmware-images"
CROS_WORKON_LOCALNAME="platform/hps-firmware-images"

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

	insinto "/usr/lib/firmware/hps"
	doins "${S}"/firmware-bin/*

	dobin "${S}"/bin/*
}
