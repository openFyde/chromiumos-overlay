# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=7

CROS_WORKON_COMMIT="9b62a8fb4fce145fcb084f4ae6c08ee647fbd841"
CROS_WORKON_TREE="95718b4fac3b337cc9b2f534fc3483487eec594a"
CROS_WORKON_PROJECT="chromiumos/third_party/u-boot"
CROS_WORKON_LOCALNAME="u-boot/files"
CROS_WORKON_SUBTREE="tools/dtoc"

PYTHON_COMPAT=( python3_6 python3_7 python3_8 )

inherit cros-workon distutils-r1

DESCRIPTION="Dtoc tool (from U-Boot) for converting devicetree files to C"
HOMEPAGE="https://www.denx.de/wiki/U-Boot"

LICENSE="GPL-2"
SLOT="0/0"
KEYWORDS="*"
IUSE=""

BDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="dev-vcs/patman"

src_unpack() {
	cros-workon_src_unpack

	S+=/tools/dtoc
}
