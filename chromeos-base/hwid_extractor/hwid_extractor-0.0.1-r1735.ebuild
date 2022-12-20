# Copyright 2021 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT=("53f38a1e63f57ae2a4f9f734bed1990b3bd0e0dc" "fa6790e1c39d1a4ea6f8c76fb118f76de615478b")
CROS_WORKON_TREE=("119ad00bb4b2636087003732e9e9f31b6d8536d4" "b80abcd0322a79348a266a01ff4c1a0deb3d467c" "2d31603031a4273d74b9019b71a6893a585badee" "f061c157c7795a4a4f6abbee1670df7bc581e21b" "06444335376f8165c3d7765ae1040d099eef806c")
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
