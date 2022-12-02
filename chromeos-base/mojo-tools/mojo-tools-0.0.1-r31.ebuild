# Copyright 2021 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_WORKON_COMMIT="8366224bf5c2c859cf1583668be22e5392699f9a"
CROS_WORKON_TREE="1a42da027573aa6d67c73541847eafcbe631e3fb"
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
