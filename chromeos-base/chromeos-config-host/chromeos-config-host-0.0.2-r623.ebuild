# Copyright 2016 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT="a7c307ba34534b63ef2f5cb806a2c7d53997102f"
CROS_WORKON_TREE="8990b0761ef52cd3d53ecfd588738ab7aac39593"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_SUBTREE="chromeos-config"

PYTHON_COMPAT=( python{3_6,3_7} )

inherit cros-workon distutils-r1

DESCRIPTION="Chrome OS configuration host tools"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/chromeos-config"

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
