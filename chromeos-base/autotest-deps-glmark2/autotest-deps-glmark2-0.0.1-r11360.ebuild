# Copyright 2012 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="71e66dec8d569ae4ac7d9e7395ed6650ad24d190"
CROS_WORKON_TREE="90bcd07d21b48f37fa54008440038815c72fe436"
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
