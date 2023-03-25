# Copyright 2011 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="4d5f4125e8d1e72d19b36e45f890bc3b9e62ebc0"
CROS_WORKON_TREE="881245d436ca25a6a2ce36a4ff853586d143eef6"
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
