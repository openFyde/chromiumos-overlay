# Copyright 2016 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT="d6ad98b44b72b762f68ac517167833fd6036f113"
CROS_WORKON_TREE="c081dfdce33cdc23b6c225e85ad84e61bb77b521"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_SUBTREE="chromeos-config"

PYTHON_COMPAT=( python3_{6..9} )

inherit cros-workon distutils-r1

DESCRIPTION="Chrome OS configuration host tools"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/chromeos-config"

LICENSE="BSD-Google"
SLOT=0
KEYWORDS="*"

RDEPEND="
	>=sys-fs/squashfs-tools-4.3
	dev-python/jinja[${PYTHON_USEDEP}]
	!<chromeos-base/chromeos-config-tools-0.0.4
"

DEPEND="
	${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

src_unpack() {
	cros-workon_src_unpack
	S+="/chromeos-config"
}
