# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

# This ebuild is for running tast DLC test in the lab and local dev setup.
# For future DLC autotests, a new installation process needs to be re-designed.

EAPI=6

CROS_WORKON_COMMIT="46b0c6ef3581b4b039a50956807fded2e52652d6"
CROS_WORKON_TREE=("91cefa956fd6a601df590774fe416e68531d57fc" "a7054021f1976533096a10b32b8b2e4217a1d66b" "83d37d74dcc8f80d9781168656326d7ae58f6d54")
CROS_WORKON_PROJECT="chromiumos/platform/dev-util"
CROS_WORKON_LOCALNAME="dev"
CROS_WORKON_OUTOFTREE_BUILD="1"
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_SUBTREE="nebraska stateful_update quick-provision"

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
	dobin quick-provision/quick-provision
}

src_test() {
	# Run the unit tests.
	cd nebraska
	./run_unittests || die
}
