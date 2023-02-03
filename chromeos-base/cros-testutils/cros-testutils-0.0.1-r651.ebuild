# Copyright 2011 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="0a39fdfe7449ebb5b84f40d6073039743c66c588"
CROS_WORKON_TREE="ac1fe95470ab2aa1f1f237f05a0e9f7d01c18c0e"
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
