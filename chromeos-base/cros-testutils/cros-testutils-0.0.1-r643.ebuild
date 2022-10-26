# Copyright 2011 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="39525089de13a80d658856c1834d0d10ab47b667"
CROS_WORKON_TREE="680eeed12e9404226db544f7a74bccebba3d527b"
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
