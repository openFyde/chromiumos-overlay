# Copyright 2023 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="5c3ddace3488aa2a4109507e40d8431eea6fe312"
CROS_WORKON_TREE="dbf03e299d43b02d19c9638bc8a1f99fe42e6a7a"
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
