# Copyright 2014 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="5dbb26f0e81f7ffd6a19801310dbf5bfc14ea756"
CROS_WORKON_TREE="6fc53cda9d4671557aa5344bfc7a19a140616be9"
CROS_WORKON_PROJECT="chromiumos/third_party/autotest"
CROS_WORKON_LOCALNAME="third_party/autotest/files"

inherit cros-workon autotest-deponly

DESCRIPTION="Autotest cellular deps"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/third_party/autotest/"
SRC_URI=""
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="*"

# Autotest enabled by default.
IUSE="+autotest"

AUTOTEST_DEPS_LIST="fakegudev fakemodem"
AUTOTEST_CONFIG_LIST=
AUTOTEST_PROFILERS_LIST=

# NOTE: For deps, we need to keep *.a
AUTOTEST_FILE_MASK="*.tar.bz2 *.tbz2 *.tgz *.tar.gz"

RDEPEND="!<chromeos-base/autotest-deps-0.0.3"

# deps/fakegudev
RDEPEND="${RDEPEND}
	virtual/libgudev
"

# deps/fakemodem
RDEPEND="${RDEPEND}
	chromeos-base/autotest-fakemodem-conf
	dev-libs/dbus-glib
"
DEPEND="${RDEPEND}"
