# Copyright 2013 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="5529bc1c9234aab58eb926fb22403e3ba65f4f4c"
CROS_WORKON_TREE="e3fbf36efc149c876210ef2d6335ddbca399c2aa"
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
