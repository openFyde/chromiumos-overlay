# Copyright 2019 The Chromium OS Authors. All rights reserved.
# This file distributed under the terms of the BSD license.

EAPI="6"

CROS_WORKON_COMMIT="2fa0a14ea47f7d1c362e40d84cbe5d08484e3875"
CROS_WORKON_TREE="f07ab10a62f1861760aafae8e5d502dfcb0778a9"
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
