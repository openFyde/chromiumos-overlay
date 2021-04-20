# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=7

CROS_WORKON_COMMIT="463f34b47ff7baeafbcf01012f6445b1970aa53f"
CROS_WORKON_TREE="675d65d09f953222d0e83ea6be66861de9c00cdf"
CROS_WORKON_PROJECT="chromiumos/platform/ec"
CROS_WORKON_LOCALNAME="platform/ec"
CROS_WORKON_SUBTREE="zephyr/zmake"

PYTHON_COMPAT=( python{3_6,3_7,3_8,3_9} )

inherit cros-workon distutils-r1

DESCRIPTION="Tools used for building Zephyr OS"
HOMEPAGE="http://src.chromium.org"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE=""

BDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="
	dev-embedded/binman
	dev-python/colorama[${PYTHON_USEDEP}]
	dev-python/docopt[${PYTHON_USEDEP}]
	dev-python/hypothesis[${PYTHON_USEDEP}]
	dev-python/jsonschema[${PYTHON_USEDEP}]
	dev-python/pykwalify[${PYTHON_USEDEP}]
	dev-python/pytest[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/testfixtures[${PYTHON_USEDEP}]
	dev-util/ninja
	sys-apps/dtc
"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

src_unpack() {
	cros-workon_src_unpack
	S+="/zephyr/zmake"
}

src_test() {
	pytest "${S}" || die "Tests fail with ${EPYTHON}"
}
