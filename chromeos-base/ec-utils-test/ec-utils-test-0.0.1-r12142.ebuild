# Copyright 2016 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="89bd1915da0cf5b496b522063927091692d49b4d"
CROS_WORKON_TREE="64b3e5bfd63ba6280bbed31181b0fc0336b0ddaa"
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
