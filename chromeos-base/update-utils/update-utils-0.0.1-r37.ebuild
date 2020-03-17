# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

# This ebuild is for running tast DLC test in the lab and local dev setup.
# For future DLC autotests, a new installation process needs to be re-designed.

EAPI=6

CROS_WORKON_COMMIT="ded2c7df7eeeb076040a3434561b012c83df5f05"
CROS_WORKON_TREE=("e77f684eb94b8e27f610d6f5932888fb8897ffd0" "a7054021f1976533096a10b32b8b2e4217a1d66b" "798e01ef051b54ee67a88a5fc7818ecadc893275")
PYTHON_COMPAT=( python2_7 python3_{6,7} )

CROS_WORKON_PROJECT="chromiumos/platform/dev-util"
CROS_WORKON_LOCALNAME="platform/dev"
CROS_WORKON_OUTOFTREE_BUILD="1"
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_SUBTREE="nebraska stateful_update quick-provision"

inherit cros-workon python-r1

DESCRIPTION="A set of utilities for updating Chrome OS."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/dev-util/"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"

RDEPEND="!chromeos-base/gmerge"

# Add an empty src_compile() so we bypass compile stage.
src_compile() { :; }

src_install() {
	into /usr/local
	dobin nebraska/nebraska.py
}

src_test() {
	# Run the unit tests.
	python_test() {
		"$PYTHON" nebraska/nebraska_unittest.py || die
	}
	python_foreach_impl python_test
}
