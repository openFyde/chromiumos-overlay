# Copyright 2013 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="f4b225485d7d05a9d409e99958eb82fbd906cd18"
CROS_WORKON_TREE="e81d98296c954229f8a23eb55bc4fdb1974ab026"
CROS_WORKON_PROJECT="chromiumos/third_party/autotest"
CROS_WORKON_LOCALNAME="third_party/autotest/files"

inherit cros-workon autotest-deponly

DESCRIPTION="Dependencies for WebGL many planets deep test"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/third_party/autotest/"
SRC_URI=""

LICENSE="GPL-2"
KEYWORDS="*"

# Autotest enabled by default.
IUSE="+autotest"

AUTOTEST_DEPS_LIST="webgl_mpd"

# NOTE: For deps, we need to keep *.a
AUTOTEST_FILE_MASK="*.tar.bz2 *.tbz2 *.tgz *.tar.gz"
