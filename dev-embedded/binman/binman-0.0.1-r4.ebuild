# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=7

CROS_WORKON_COMMIT="a4f2485b69f4d71aa98a96a0b7cd6f53d515be7e"
CROS_WORKON_TREE="d5d5873c0af0d82faaa65af8e909d8768789750b"
CROS_WORKON_PROJECT="chromiumos/third_party/u-boot"
CROS_WORKON_LOCALNAME="u-boot/files"
CROS_WORKON_SUBTREE="tools/binman"

PYTHON_COMPAT=( python3_6 python3_7 python3_8 )

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
