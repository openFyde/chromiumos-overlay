# Copyright 2021 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT=("63c733a879ceee61b3c7482d5bc1f5d1ba56ef9f" "9b1ff19f775c932ef62dbc171c3407e4d0d847aa")
CROS_WORKON_TREE=("3c907aa1dbce91c412a3d1e28ea0adf988516c42" "b23d2b4aa0617db517029fbc2d957d124345bd0e" "111f71cbb9fa5cb3abc512655b54f5ac7ca1bbf1" "40cfabff665bdf6dabb830035db99f05ce2d073d" "06444335376f8165c3d7765ae1040d099eef806c")
CROS_WORKON_PROJECT=("chromiumos/platform/factory" "chromiumos/chromite")
CROS_WORKON_LOCALNAME=("platform/factory" "../chromite")
CROS_WORKON_SUBTREE=("py" "lib bin scripts PRESUBMIT.cfg")
CROS_WORKON_DESTDIR=("${S}" "${S}/chromite")

inherit cros-workon

DESCRIPTION="Chrome OS HWID Extractor"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/factory/"
SRC_URI=""
LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="cros_host"

RDEPEND="chromeos-base/vboot_reference
	chromeos-base/vpd
	dev-python/pyserial
	dev-util/hdctools
	sys-apps/flashrom
"

src_install() {
	local lib="/usr/local"
	if use cros_host; then
		lib="/usr/lib"
	fi
	emake -C py/hwid_extractor \
		DESTDIR="${D}" \
		LIB_DIR="${lib}" \
		CHROMITE_PATH="${S}/chromite" \
		CHROMITE_SRC_PATH="${S}/chromite/lib" \
		install
}
