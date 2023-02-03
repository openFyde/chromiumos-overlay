# Copyright 2017 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="bf88ba7e1bd291480bf1ba2415860db5d9f9428c"
CROS_WORKON_TREE=("5a857fb996a67f6c9781b916ba2d6076e9dcd0a6" "ae5b2f739827b5d82436bf84a13eeb378bae2ccd" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
CROS_WORKON_INCREMENTAL_BUILD="1"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk arc/mount-passthrough .gn"

PLATFORM_SUBDIR="arc/mount-passthrough"

inherit cros-workon platform

DESCRIPTION="Mounts the specified directory with different owner UID and GID"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/arc/mount-passthrough"

LICENSE="BSD-Google"
KEYWORDS="*"

IUSE="arcpp"

COMMON_DEPEND="=sys-fs/fuse-2*
	sys-libs/libcap:="
RDEPEND="
	${COMMON_DEPEND}
	dev-util/shflags
"
DEPEND="${COMMON_DEPEND}"
