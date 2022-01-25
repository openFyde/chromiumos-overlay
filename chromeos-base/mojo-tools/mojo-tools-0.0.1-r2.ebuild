# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_WORKON_COMMIT="eb6f7fcab5e8bd2afb87697025d3bae617c62ef0"
CROS_WORKON_TREE="7c180c8f40535848d96646a5a51ae46bff8743d2"
CROS_WORKON_PROJECT=("aosp/platform/external/libchrome")
CROS_WORKON_LOCALNAME=("aosp/external/libchrome")
CROS_WORKON_EGIT_BRANCH=("master")
CROS_WORKON_SUBTREE=("mojo/public/tools")
PYTHON_COMPAT=( python3_{6..9} )

inherit cros-workon python-r1

DESCRIPTION="Mojo python tools for binding generating."
HOMEPAGE="https://chromium.googlesource.com/chromium/src/+/HEAD/mojo/public/tools/mojom/"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE=""

RDEPEND="
	dev-python/jinja[${PYTHON_USEDEP}]
"

src_install() {
	install_python() {
		python_domodule mojo/public/tools/mojom/mojom
		python_domodule mojo/public/tools/bindings/generators
	}
	python_foreach_impl install_python
}
