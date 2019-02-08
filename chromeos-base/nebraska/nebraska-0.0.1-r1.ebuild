# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

# This ebuild is for running tast DLC test in the lab and local dev setup.
# For future DLC autotests, a new installation process needs to be re-designed.

EAPI=6

CROS_WORKON_COMMIT="2a792fa977adae082fb26bb66d9282fe7a0e8c50"
CROS_WORKON_TREE="1e303830fc8af85ef36da591f6a9799cb186d13f"
CROS_WORKON_PROJECT="chromiumos/platform/dev-util"
CROS_WORKON_LOCALNAME="dev"
CROS_WORKON_OUTOFTREE_BUILD="1"
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_SUBTREE="nebraska"

inherit cros-workon

DESCRIPTION="Nebraska is a mock Omaha update server written in python"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/dev-util/+/master/nebraska"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"

# Add an empty src_compile() so we bypass compile stage.
src_compile() { :; }

src_install() {
	insinto /usr/local/bin
	doins nebraska/nebraska.py
}
