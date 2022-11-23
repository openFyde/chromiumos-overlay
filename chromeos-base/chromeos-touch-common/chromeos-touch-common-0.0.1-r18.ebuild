# Copyright 2019 The ChromiumOS Authors
# Distributed under the terms of the BSD license.

EAPI=7
CROS_WORKON_COMMIT="2a014a23ee1c24a1a1dc873bbc83edd1cf60af1a"
CROS_WORKON_TREE="32a14e98e4a0be7d8e80be0ef8630a56423db34a"
CROS_WORKON_PROJECT="chromiumos/platform/touch_updater"
CROS_WORKON_LOCALNAME="platform/touch_updater"
CROS_WORKON_SUBTREE="common"
CROS_WORKON_OUTOFTREE_BUILD=1

inherit cros-workon

DESCRIPTION="Common shell libraries for touch firmware updater wrapper scripts"
HOMEPAGE="https://www.chromium.org/chromium-os"

LICENSE="BSD-Google"
SLOT="0/0"
KEYWORDS="*"

RDEPEND="
	sys-apps/mosys
	!<chromeos-base/touch_updater-0.0.1-r167
"

src_install() {
	insinto "/opt/google/touch/scripts"
	doins common/scripts/*.sh
}
