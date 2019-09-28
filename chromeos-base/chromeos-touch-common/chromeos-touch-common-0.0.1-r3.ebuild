# Copyright (c) 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the BSD license.

EAPI="6"
CROS_WORKON_COMMIT="dbbb107a7922e6b3f705c2ae3641831b8c11a990"
CROS_WORKON_TREE="2d41ee96b3204a0d53c1ea46bb9658dce509b02d"
CROS_WORKON_PROJECT="chromiumos/platform/touch_updater"
CROS_WORKON_LOCALNAME="touch_updater"
CROS_WORKON_SUBTREE="common"
CROS_WORKON_OUTOFTREE_BUILD=1

inherit cros-workon

DESCRIPTION="Common shell libraries for touch firmware updater wrapper scripts"
HOMEPAGE="https://www.chromium.org/chromium-os"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"

RDEPEND="
	sys-apps/mosys
	!<chromeos-base/touch_updater-0.0.1-r167
"

src_install() {
	insinto "/opt/google/touch/scripts"
	doins common/scripts/*.sh
}
