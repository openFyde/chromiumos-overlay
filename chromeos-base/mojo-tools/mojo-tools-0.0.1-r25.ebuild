# Copyright 2021 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_WORKON_COMMIT="42aef5197967003277876e97ba1bc7fe9bbc7523"
CROS_WORKON_TREE="6c859b5fe4090df05f48cc351be1a2c36ab2978c"
CROS_WORKON_PROJECT=("chromiumos/platform/libchrome")
CROS_WORKON_LOCALNAME=("platform/libchrome")
CROS_WORKON_EGIT_BRANCH=("main")
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
