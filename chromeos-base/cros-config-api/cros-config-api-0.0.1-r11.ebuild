# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=7

CROS_WORKON_COMMIT="4a7ea2b9b4a22e7067dc0c6009416e78197c6ff2"
CROS_WORKON_TREE="a55af66f482f3943cd27cfd2465b6d1f3926f2d2"
CROS_WORKON_PROJECT="chromiumos/config"
CROS_WORKON_LOCALNAME="config"
CROS_WORKON_SUBTREE="python"

PYTHON_COMPAT=( python{3_6,3_7} )

inherit cros-workon distutils-r1

DESCRIPTION="Provides python bindings to the config API"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/config/+/master/python/"

LICENSE="BSD-Google"
SLOT=0
KEYWORDS="*"

RDEPEND=""

DEPEND="
	${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

src_unpack() {
	cros-workon_src_unpack
	S+="/python"
}
