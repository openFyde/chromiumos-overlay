# Copyright 2014 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT="9bd96f5866975b97f04affd4ae8eb38cbaaad9f7"
CROS_WORKON_TREE="4a1ffdaaa142e89a2087738578f0be87c90a2619"
PYTHON_COMPAT=( python3_{6..9} )

CROS_WORKON_PROJECT="chromiumos/third_party/autotest"
CROS_WORKON_LOCALNAME="third_party/autotest/files"

inherit cros-sanitizers cros-workon autotest python-any-r1

DESCRIPTION="Graphics autotests"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/third_party/autotest/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="*"
# Enable autotest by default.
IUSE="+autotest"

RDEPEND="
	!<chromeos-base/autotest-tests-0.0.3
	chromeos-base/autotest-deps-graphics
	tests_graphics_Gbm? ( media-libs/minigbm )
	tests_graphics_GLBench? ( chromeos-base/glbench )
"
DEPEND="${RDEPEND}"

IUSE_TESTS="
	+tests_graphics_Gbm
	+tests_graphics_GLBench
	+tests_graphics_KernelMemory
	+tests_graphics_parallel_dEQP
	+tests_graphics_Power
"

IUSE="${IUSE} ${IUSE_TESTS}"

AUTOTEST_FILE_MASK="*.a *.tar.bz2 *.tbz2 *.tgz *.tar.gz"

src_configure() {
	sanitizers-setup-env
	default
}
