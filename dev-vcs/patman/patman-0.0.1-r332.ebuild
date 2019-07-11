# Copyright (c) 2012 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI="6"

CROS_WORKON_COMMIT="c526bbe09b550d40fba290237dd1caa5b5736277"
CROS_WORKON_TREE="e3ca83e6c3ce66f7eda2101a0be2ec7f825179ad"
CROS_WORKON_PROJECT="chromiumos/third_party/u-boot"
CROS_WORKON_LOCALNAME="u-boot/files"
CROS_WORKON_SUBTREE="tools/patman"

PYTHON_COMPAT=( python2_7 )

inherit cros-workon distutils-r1

DESCRIPTION="Patman tool (from U-Boot) for sending patches upstream"
HOMEPAGE="https://www.denx.de/wiki/U-Boot"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="*"
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND=""

src_prepare() {
	cd tools/patman
	distutils-r1_src_prepare
}

src_compile() {
	cd tools/patman
	distutils-r1_src_compile
}

src_install() {
	cd tools/patman
	distutils-r1_src_install
}
