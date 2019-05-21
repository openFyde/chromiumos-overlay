# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

# This ebuild is for running tast DLC test in the lab and local dev setup.
# For future DLC autotests, a new installation process needs to be re-designed.

EAPI=6

CROS_WORKON_COMMIT="ba8503e5b5eee95a3fd76121a14a8c8a08024459"
CROS_WORKON_TREE="2a99aa65dffaef70c1315ba1abb5ee7a7b0d6bc8"
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
