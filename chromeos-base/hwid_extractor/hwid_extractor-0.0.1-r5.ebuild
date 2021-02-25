# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT=("f04615bcef385219d6700c9403ac74733ad84195" "3ac0388b25ced1c4b073cdeb2e3e6640997f6513")
CROS_WORKON_TREE=("76cf4237e9cc9ecd62b6036e6cc9c17a1d558305" "14ed3e5c92d7fcf6973f58dd3854013063c91706")
CROS_WORKON_PROJECT=("chromiumos/platform/factory" "chromiumos/chromite")
CROS_WORKON_LOCALNAME=("platform/factory" "../chromite")
CROS_WORKON_SUBTREE=("py" "lib")
CROS_WORKON_DESTDIR=("${S}" "${S}/chromite")

inherit cros-workon

DESCRIPTION="Chrome OS HWID Extractor"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/factory/"
SRC_URI=""
LICENSE="BSD-Google"
KEYWORDS="*"

RDEPEND="chromeos-base/vboot_reference
	chromeos-base/vpd
	dev-python/pyserial
	dev-util/hdctools
	sys-apps/flashrom
"

src_install() {
	emake -C py/hwid_extractor \
		DESTDIR="${D}" \
		CHROMITE_LIB_PATH="${S}/chromite/lib" \
		install
}
