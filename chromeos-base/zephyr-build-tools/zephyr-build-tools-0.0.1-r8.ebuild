# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=7

CROS_WORKON_COMMIT="49d383f8f74a227f1b5f3a5e7d282cf7985a0342"
CROS_WORKON_TREE="139b8e182a584b259d5f93861180b224ee366549"
CROS_WORKON_PROJECT="chromiumos/platform/zephyr-chrome"
CROS_WORKON_LOCALNAME="platform/zephyr-chrome"
CROS_WORKON_SUBTREE="util"

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
	dev-python/colorama[${PYTHON_USEDEP}]
	dev-python/docopt[${PYTHON_USEDEP}]
	dev-python/jsonschema[${PYTHON_USEDEP}]
	dev-python/pykwalify[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-util/ninja
"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

src_unpack() {
	cros-workon_src_unpack
	S+="/util"
}
