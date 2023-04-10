# Copyright 2023 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="14be69f0fda636b11d5ad10e7a508f80ded9cbc2"
CROS_WORKON_TREE="c231d8ca1a51e09b3870d656696672d28e0d109d"
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="../platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_DESTDIR="${S}/platform2"
CROS_WORKON_SUBTREE="camera/app"

PLATFORM_SUBDIR="camera/app"
WANT_LIBCHROME="no"

PYTHON_COMPAT=( python3_{6..9} )

inherit cros-workon platform distutils-r1

DESCRIPTION="Command line tool for CCA (ChromeOS Camera App)"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/camera/app"

LICENSE="BSD-Google"
SLOT="0/0"
KEYWORDS="*"

RDEPEND="
	dev-python/ws4py[${PYTHON_USEDEP}]
"

DEPEND="
	${RDEPEND}
"
