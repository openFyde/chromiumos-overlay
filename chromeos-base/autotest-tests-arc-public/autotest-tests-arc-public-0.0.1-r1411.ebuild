# Copyright 2016 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT="3aeecfe0504fa745b846821568c79df15861888f"
CROS_WORKON_TREE="3dc133c85504d52f3b1ca54c23acdbc0449dadbc"
CROS_WORKON_PROJECT="chromiumos/third_party/autotest"
CROS_WORKON_LOCALNAME="third_party/autotest/files"

inherit autotest cros-workon flag-o-matic

DESCRIPTION="Public ARC autotests"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"

RDEPEND="
	dev-python/pyxattr
	chromeos-base/chromeos-chrome
	chromeos-base/autotest-chrome
	chromeos-base/telemetry
	"

DEPEND="${RDEPEND}"

IUSE="
	+autotest
"

src_prepare() {
	# Telemetry tests require the path to telemetry source to exist in order to
	# build. Copy the telemetry source to a temporary directory that is writable,
	# so that file removals in Telemetry source can be performed properly.
	export TMP_DIR="$(mktemp -d)"
	cp -r "${SYSROOT}/usr/local/telemetry" "${TMP_DIR}"
	export PYTHONPATH="${TMP_DIR}/telemetry/src/third_party/catapult/telemetry"
	autotest_src_prepare
}

