# Copyright 2018 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="895291cd429f847770ca6fb96eae6edae298cb55"
CROS_WORKON_TREE=("6836462cc3ac7e9ff3ce4e355c68c389eb402bff" "67abcb31f8e2ea7fa4a587e5e583b6e5ef753c84" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
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
