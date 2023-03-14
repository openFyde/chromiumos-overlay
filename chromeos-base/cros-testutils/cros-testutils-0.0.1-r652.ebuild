# Copyright 2011 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="838c4e7284d34c3e8bd93bd0f6707de4fa850958"
CROS_WORKON_TREE="51f264d256db60c0d4cb80a7f19fdc62ccbc1799"
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
