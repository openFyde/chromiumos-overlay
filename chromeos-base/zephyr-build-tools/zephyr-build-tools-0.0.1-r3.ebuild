# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=7

CROS_WORKON_COMMIT="ea6664d04a0219d372dab1afb5e69efdf2e3458a"
CROS_WORKON_TREE="8f9d5b02495ea5039abb18f2fafc72d08f04359e"
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
