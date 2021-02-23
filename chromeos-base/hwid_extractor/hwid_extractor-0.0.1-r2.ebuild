# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT=("40d4173078c44a3bd3cf3a6f9799bbdf32cf3b9b" "fdb2d73fe93ee0389352590ef599194fbec162e7")
CROS_WORKON_TREE=("76cf4237e9cc9ecd62b6036e6cc9c17a1d558305" "7b87c9a380b11f2773db66bf5c8dcd67894257e1")
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
