# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_WORKON_COMMIT="2a60bd89ca23703cb8cc358988783b5a77efda7d"
CROS_WORKON_TREE="db6d87dad1e5bd24016004a74d55f4108b3fac74"
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
