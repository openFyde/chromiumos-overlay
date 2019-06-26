# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

# This ebuild is for running tast DLC test in the lab and local dev setup.
# For future DLC autotests, a new installation process needs to be re-designed.

EAPI=6

CROS_WORKON_COMMIT="499a6ed15ec97c742ad12082dba9db630d6c6762"
CROS_WORKON_TREE="60c437d847c531d4c7266ebad34785b2a2a0fe16"
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
