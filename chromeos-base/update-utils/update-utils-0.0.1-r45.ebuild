# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

# This ebuild is for running tast DLC test in the lab and local dev setup.
# For future DLC autotests, a new installation process needs to be re-designed.

EAPI=6

CROS_WORKON_COMMIT="af4e19d3a7e5d96fef6ee0ca1b647d9c07f2efb5"
CROS_WORKON_TREE="0b76312ca303c7e878b6b14239bac84c5baf521a"
PYTHON_COMPAT=( python2_7 python3_{6,7} )

CROS_WORKON_PROJECT="chromiumos/platform/dev-util"
CROS_WORKON_LOCALNAME="platform/dev"
CROS_WORKON_OUTOFTREE_BUILD="1"
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_SUBTREE="nebraska"

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
