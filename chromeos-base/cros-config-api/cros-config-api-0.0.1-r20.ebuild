# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=7

CROS_WORKON_COMMIT="7c1a6361d6bc26f445e6ead5036823662ad990f7"
CROS_WORKON_TREE="b0b9d142ecddf4ccab16609e27a6b9d419f003c7"
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
