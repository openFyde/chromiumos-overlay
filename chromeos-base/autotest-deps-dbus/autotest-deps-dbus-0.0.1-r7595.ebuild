# Copyright 2018 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="b1274caf5bdb12772203fbe326e6786f3b1759a7"
CROS_WORKON_TREE="67da6b31d529e5bf100cb8d92388b3143347308c"
CROS_WORKON_PROJECT="chromiumos/third_party/autotest"
CROS_WORKON_LOCALNAME="third_party/autotest/files"

inherit cros-workon autotest-deponly

DESCRIPTION="Autotest D-Bus deps"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/third_party/autotest/"
SRC_URI=""
LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"

# Autotest enabled by default.
IUSE="+autotest"

AUTOTEST_DEPS_LIST="dbus_protos"

# NOTE: For deps, we need to keep *.a
AUTOTEST_FILE_MASK="*.tar.bz2 *.tbz2 *.tgz *.tar.gz"

DEPEND="chromeos-base/system_api
	dev-libs/protobuf:=
"

# Calling this here, so tests using this dep don't have to call setup_dep().
src_prepare() {
	autotest-deponly_src_prepare
}
