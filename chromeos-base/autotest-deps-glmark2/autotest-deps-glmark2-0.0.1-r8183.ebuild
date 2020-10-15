# Copyright (c) 2012 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="b66e5c8dc0801a586961adc9a79504d45844f97a"
CROS_WORKON_TREE="9635d3c90a37bb5e4d0d47990f7662201d55e395"
CROS_WORKON_PROJECT="chromiumos/third_party/autotest"
CROS_WORKON_LOCALNAME="third_party/autotest/files"

inherit cros-sanitizers cros-workon autotest-deponly

DESCRIPTION="Autotest glmark2 dependency"
HOMEPAGE="https://launchpad.net/glmark2"
SRC_URI=""

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="*"

# Autotest enabled by default.
IUSE="-asan +autotest"

AUTOTEST_DEPS_LIST="glmark2"

# deps/glmark2
RDEPEND="
	app-benchmarks/glmark2
"

DEPEND="${RDEPEND}"

src_configure() {
	sanitizers-setup-env
	default
}
