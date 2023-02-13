# Copyright 2016 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="13b898fbf00ed8aced0d9758c323a3cd58a8c6a0"
CROS_WORKON_TREE="fd574df365cfc6eac1dee177ffb546e4f3c956de"
CROS_WORKON_PROJECT="chromiumos/platform/ec"
CROS_WORKON_LOCALNAME="platform/ec"
CROS_WORKON_INCREMENTAL_BUILD=1
PYTHON_COMPAT=( python3_{6..9} pypy3 )

# This ebuild is upreved via PuPR, so disable the normal uprev process for
# cros-workon ebuilds.
#
# To uprev manually, run:
#    cros_mark_as_stable --force --overlay-type private --packages \
#     chromeos-base/ec-utils-test commit
CROS_WORKON_MANUAL_UPREV="1"

inherit cros-workon python-r1

DESCRIPTION="Chrome OS EC Utility Helper"

HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/ec/"
SRC_URI=""

LICENSE="BSD-Google"
SLOT="0/0"
KEYWORDS="*"
IUSE="biod cr50_onboard ti50_onboard"

# flash_fp_mcu depends on stm32mon (ec-devutils)
RDEPEND="
	${PYTHON_DEPS}
	chromeos-base/ec-utils
	biod? (
		chromeos-base/ec-devutils
		dev-util/shflags
	      )
"

src_compile() {
	tc-export CC

	if use cr50_onboard || use ti50_onboard; then
		emake -C extra/rma_reset
	fi
}

src_install() {
	dobin "util/battery_temp"
	dosbin "util/inject-keys.py"

	if use cr50_onboard || use ti50_onboard; then
		dobin "extra/rma_reset/rma_reset"
	fi

	if use biod; then
		einfo "Installing flash_fp_mcu and fptool"
		dobin "util/flash_fp_mcu"
		newbin "util/fptool.py" "fptool"
	fi
}
