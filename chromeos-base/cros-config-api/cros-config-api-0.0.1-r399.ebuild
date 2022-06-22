# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=7

CROS_WORKON_COMMIT="e5b054a0f80dca0e18f0d908772d7f24348f91e1"
CROS_WORKON_TREE=("d96fec086a53f85a78b83285e248a88c6230d6de" "2db339399b419ec7b534c28797f434668340c7be" "129096721ca4029b649295574e9904b0b6cf352e")
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
