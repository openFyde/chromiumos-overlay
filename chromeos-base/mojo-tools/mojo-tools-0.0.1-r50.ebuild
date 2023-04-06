# Copyright 2021 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_WORKON_COMMIT="84b7fe0d6967fa193102e3e066bce0d574b592d6"
CROS_WORKON_TREE="90f6fe95e2334b7ca96d9f010adea00d833425e0"
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

RDEPEND="${PYTHON_DEPS}
	dev-python/jinja[${PYTHON_USEDEP}]
"
DEPEND="${PYTHON_DEPS}"

src_install() {
	install_python() {
		python_domodule mojo/public/tools/mojom/mojom
		python_domodule mojo/public/tools/bindings/generators
	}
	python_foreach_impl install_python
}
