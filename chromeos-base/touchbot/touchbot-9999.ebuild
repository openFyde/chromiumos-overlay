# Copyright (c) 2012 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 )

CROS_WORKON_PROJECT="chromiumos/platform/touchbot"
CROS_WORKON_LOCALNAME="platform/touchbot"

inherit cros-workon distutils-r1

DESCRIPTION="Suite of control scripts for the Touchbot"
HOMEPAGE="http://www.chromium.org/"

LICENSE="GPL-2"
SLOT="0/0"
KEYWORDS="~*"
