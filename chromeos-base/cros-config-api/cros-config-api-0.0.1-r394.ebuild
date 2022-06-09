# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=7

CROS_WORKON_COMMIT="10d7038c71ae51e66a3a82d16f06b246a24b8e4d"
CROS_WORKON_TREE=("50dbb9107146b0d9e33519344fc077823c61a2fe" "d78c2ea569f298f4a312737ff5b49ebb908186e1" "ebee2d66b5001b4b163af0b285e489c22cca56a0")
CROS_WORKON_PROJECT="chromiumos/config"
CROS_WORKON_LOCALNAME="config"
CROS_WORKON_SUBTREE="python go test"

PYTHON_COMPAT=( python3_{6..9} )
DISTUTILS_USE_SETUPTOOLS=bdepend

inherit cros-workon distutils-r1

DESCRIPTION="Provides python and go bindings to the config API"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/config/+/master/python/"

LICENSE="BSD-Google"
SLOT=0
KEYWORDS="*"

RDEPEND="
	dev-go/genproto
	dev-go/grpc
	dev-go/protobuf-legacy-api
"

DEPEND="
	${RDEPEND}
"

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
