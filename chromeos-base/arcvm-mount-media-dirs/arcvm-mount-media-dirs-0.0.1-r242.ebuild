# Copyright 2020 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="ee11aa653a6e53c49ede4de52ac6f2280f2ffd73"
CROS_WORKON_TREE=("ca7895485a50f354a0c396417657ff67fbbdf40f" "dc7c34c4e0cd7a3f50af25d0a8bf7766e566f20f" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
CROS_WORKON_INCREMENTAL_BUILD="1"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk arc/vm/media-sharing-services .gn"

PLATFORM_SUBDIR="arc/vm/media-sharing-services"

inherit cros-workon platform

# TODO(b/269060379): Rename this package to arcvm-media-sharing-services.
DESCRIPTION="Mount media directories on a mount point shared with ARCVM."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/arc/vm/media-sharing-services"

LICENSE="BSD-Google"
KEYWORDS="*"

RDEPEND="
	chromeos-base/mount-passthrough
"
