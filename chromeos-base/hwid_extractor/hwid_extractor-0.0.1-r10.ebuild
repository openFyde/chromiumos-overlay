# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT=("2a623ed48678ac4b7a36a7ac2f80894df1a61fac" "ec281f827142d7aba9a392f562f41ebce2a8d2f8")
CROS_WORKON_TREE=("23dfc36289faec2b9ff310fcc14bd1653b422414" "cb7050719dfe71ed0fda8fa2a10bf4063b57b605")
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
