# Copyright 2022 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=7

CROS_WORKON_COMMIT="425dac98bbe4a408dd266175d2fce36a9d3abe6f"
CROS_WORKON_TREE="250f2e0628cad0bfa6c00dd394f81ed8e98b805d"
CROS_WORKON_LOCALNAME="../platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_SUBTREE="parallax"

PYTHON_COMPAT=( python3_{6..9} )

inherit cros-workon distutils-r1

DESCRIPTION="Parallax: Visual Analysis Framework"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/parallax/"

LICENSE="BSD-Google"
SLOT="0/0"
KEYWORDS="*"
IUSE=""

BDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND=""

src_unpack() {
	cros-workon_src_unpack
	S+="/parallax"
}
