# Copyright 2021 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT=("1ed18bc203b46d12528ae1fb9eb9dc6170063472" "c4c839f5936d789c7a1d4f00e79b252928e114c2")
CROS_WORKON_TREE=("984983d875c097b8c9d07da028c2ed416430a922" "79c6024a5936e85f3a805dec4a306b9adbe532d3" "2d31603031a4273d74b9019b71a6893a585badee" "3930260d34bdf2325e963ec4f22a114982c88bd5" "06444335376f8165c3d7765ae1040d099eef806c")
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
