# Copyright 2014 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=4

CROS_WORKON_COMMIT="38e574e1ddcaf81ab793ad283a8e91871f833cad"
CROS_WORKON_TREE="270dee89df712e68f12c1e7d62f6f0b563ea929c"
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1

PLATFORM_SUBDIR="privetd"

inherit cros-workon platform user

DESCRIPTION="Privet protocol handler for Chrome OS Core"
HOMEPAGE="http://www.chromium.org/"
LICENSE="BSD-Google"
SLOT=0
KEYWORDS="*"

COMMON_DEPEND=""

RDEPEND=""

DEPEND=""

