# Copyright 2011 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="3ec12e2373c16d05db0fcc928706017476a3b955"
CROS_WORKON_TREE="2c5e47d45de80d600b67defb473a400657a0669e"
CROS_WORKON_PROJECT="chromiumos/platform/crostestutils"
CROS_WORKON_LOCALNAME="platform/crostestutils"

inherit cros-workon

DESCRIPTION="Host test utilities for ChromiumOS"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/crostestutils/"

LICENSE="BSD-Google"
KEYWORDS="*"

RDEPEND="
	dev-python/django
	"

# These are all either bash / python scripts.  No actual builds DEPS.
DEPEND=""

# Use default src_compile and src_install which use Makefile.
