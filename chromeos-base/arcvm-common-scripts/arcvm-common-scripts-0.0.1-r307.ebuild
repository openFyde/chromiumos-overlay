# Copyright 2018 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="1eadd7f2497b44f8e0c7a0731d7acb8e7fd5f486"
CROS_WORKON_TREE=("d12eaa6a060046041408b6cf0c2444c7da2bce2b" "a9083394a260d49ccc32c75c1fbde17fcfdc4176" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
CROS_WORKON_INCREMENTAL_BUILD="1"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk arc/vm/scripts .gn"

inherit cros-workon platform

PLATFORM_SUBDIR="arc/vm/scripts"

DESCRIPTION="ARCVM common scripts."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/arc/vm/scripts"

LICENSE="BSD-Google"
KEYWORDS="*"

RDEPEND="
	${RDEPEND}
	!<=chromeos-base/arc-base-0.0.1-r349
	!<=chromeos-base/arc-common-scripts-0.0.1-r132
	chromeos-base/arcvm-mount-media-dirs
"
