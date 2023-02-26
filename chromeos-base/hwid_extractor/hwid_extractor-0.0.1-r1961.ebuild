# Copyright 2021 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT=("08e4e354bbb317ac234b709f4cd507e276a855cb" "c08040fb2436d6640ff554bf440d3063b8c81f1e")
CROS_WORKON_TREE=("4ce554f51c3ca9f86a317fff68456ada6cedd86d" "a3d16b6eb2f00bf82b4613811832033d1fd511e9" "c1778e01cc2571e4a257c150748c6fd65bcc0a34" "5f6885cfc83c2a38c404f7664a2ff068e6e2d33b" "9856c7544aa8508c329258abd97a93f52571cd9c")
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
