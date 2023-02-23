# Copyright 2021 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT=("45a8a0e42e30fa7014c2468d282f4b209ec622c3" "1ca1f101bf227d378d7fbdbe88d1650aa5bd8af7")
CROS_WORKON_TREE=("90ae87f1655cbea64a1159ba5400230a72e16136" "60459907efe4de810d203f40da6fd2a524cffd74" "c1778e01cc2571e4a257c150748c6fd65bcc0a34" "cde8ac742d9f35cb69382a2373cc41b590ed2e6b" "9856c7544aa8508c329258abd97a93f52571cd9c")
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
