# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=7

CROS_WORKON_COMMIT="e9e8d39e1bc2fd5a1930a8f1e384a396bfc2e21c"
CROS_WORKON_TREE="60af5da93180c484eaa8fef721406de8549c649d"
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
	dev-python/pyyaml
	dev-python/jsonschema
"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

src_unpack() {
	cros-workon_src_unpack
	S+="/util"
}
