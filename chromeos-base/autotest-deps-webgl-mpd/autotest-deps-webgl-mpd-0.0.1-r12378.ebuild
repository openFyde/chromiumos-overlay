# Copyright 2013 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="75bc005dd26f3c08987aea95f918530c7e51935c"
CROS_WORKON_TREE="df02abdc4c7b3e6848f5f8d0f3d8cf46000d1907"
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
