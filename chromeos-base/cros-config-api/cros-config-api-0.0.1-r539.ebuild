# Copyright 2020 The ChromiumOS Authors
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=7

CROS_WORKON_COMMIT="0048e7c41a9ec089d16b10bd34584e66b04c735b"
CROS_WORKON_TREE=("e28ae18be39ee7c20ed3f3b3380654f9a759ea55" "7e569c588831fe3aad1097a117b8e2d73820e40b" "d3d49091eeb0fdf38045b4065302604e450086b3")
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
