# Copyright 2019 The Chromium OS Authors. All rights reserved.
# This file distributed under the terms of the BSD license.

EAPI="6"

CROS_WORKON_COMMIT="6d60e9d7adf88a879662bcfae3b9b1a1b4c4e4e7"
CROS_WORKON_TREE="89b40eb0f26942faa2addec11949607fca755370"
CROS_WORKON_PROJECT="chromiumos/third_party/novatek-tcon-fw-update-tool"
CROS_WORKON_LOCALNAME="novatek-tcon-fw-update-tool"

inherit cros-common.mk cros-workon

DESCRIPTION="Novatek TCON Firmware Updater"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/third_party/novatek-tcon-fw-update-tool/"

LICENSE="BSD"
SLOT="0"
KEYWORDS="*"

src_install() {
	dosbin "${OUT}"/nvt-tcon-fw-updater
}
