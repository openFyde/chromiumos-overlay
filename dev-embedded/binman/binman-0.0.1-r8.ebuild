# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=7

CROS_WORKON_COMMIT="d637294e264adfeb29f390dfc393106fd4d41b17"
CROS_WORKON_TREE="41d467c36587f7a865d87ea4817675a0aa4a9163"
CROS_WORKON_PROJECT="chromiumos/third_party/u-boot"
CROS_WORKON_LOCALNAME="u-boot/files"
CROS_WORKON_SUBTREE="tools/binman"

PYTHON_COMPAT=( python3_{6..9} )

inherit cros-workon distutils-r1

DESCRIPTION="Binman tool (from U-Boot) for creating / adjusting firmware images"
HOMEPAGE="https://www.denx.de/wiki/U-Boot"

LICENSE="GPL-2"
SLOT="0/0"
KEYWORDS="*"
IUSE=""

BDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="
	dev-embedded/dtoc
	dev-vcs/patman
"

src_unpack() {
	cros-workon_src_unpack

	S+=/tools/binman
}
