# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

# This ebuild is for running tast DLC test in the lab and local dev setup.
# For future DLC autotests, a new installation process needs to be re-designed.

EAPI=6

CROS_WORKON_COMMIT="06a1aa821f3eff82773a70409979d94284743330"
CROS_WORKON_TREE=("c8f5da9bf2ab32badda4b8c02089e80062d33093" "a7054021f1976533096a10b32b8b2e4217a1d66b")
CROS_WORKON_PROJECT="chromiumos/platform/dev-util"
CROS_WORKON_LOCALNAME="dev"
CROS_WORKON_OUTOFTREE_BUILD="1"
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_SUBTREE="nebraska stateful_update"

inherit cros-workon

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
	dobin stateful_update
	# TODO(crbug.com/940276): quick-provision here.
}

src_test() {
	# Run the unit tests.
	cd nebraska
	./run_unittests || die
}
