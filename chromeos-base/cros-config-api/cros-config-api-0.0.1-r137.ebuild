# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=7

CROS_WORKON_COMMIT="55d748aae8f0e14890844068611594b2a9ac2578"
CROS_WORKON_TREE=("44c2a3b652c36beaaa5dfcacc91ce3c92b92bf6c" "90c3bc822e3ea4088abf6765b0846a9a9dd145e5")
CROS_WORKON_PROJECT="chromiumos/config"
CROS_WORKON_LOCALNAME="config"
CROS_WORKON_SUBTREE="python go"

PYTHON_COMPAT=( python{3_6,3_7} )

inherit cros-workon distutils-r1

DESCRIPTION="Provides python and go bindings to the config API"
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
	# distutils-r1 provides src_configure, src_install and src_test steps for
	# python bindings, and they require S to be set to the Python source base
	# directory.
	S+="/python"
}

src_install() {
	distutils-r1_src_install

	# cros-go_src_install requires the directory names (which is also the go
	# package name) match between the source and destination directories.
	# However we want to add some prefix to the destination directory name.
	# source: src/config/go/api...
	# destination: src/go.chromium.org/chromiumos/config/go/api/...
	# Therefore insinto/doins are directly called here, instead of using
	# cros-go_src_install in cros-go.eclass.
	insinto /usr/lib/gopath/src/go.chromium.org/chromiumos/config
	# One directory up, because $S is modified in src_unpack in this file.
	doins -r ../go
}
