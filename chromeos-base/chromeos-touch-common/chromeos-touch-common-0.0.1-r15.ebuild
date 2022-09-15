# Copyright 2019 The ChromiumOS Authors
# Distributed under the terms of the BSD license.

EAPI=7
CROS_WORKON_COMMIT="7a4a98f1b398bb47598fa940a7e561cb22557b12"
CROS_WORKON_TREE="2f4b7841e05fce061d3991b0efb7c793cd33305a"
CROS_WORKON_PROJECT="chromiumos/platform/touch_updater"
CROS_WORKON_LOCALNAME="touch_updater"
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
