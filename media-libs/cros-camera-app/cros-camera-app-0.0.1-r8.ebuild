# Copyright 2023 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="abe6ca05df13c9f0997687bbff8d53daa4ec5c82"
CROS_WORKON_TREE="1c3cace546ab93b35fe42e87b5a8bbc7638aa5f9"
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
