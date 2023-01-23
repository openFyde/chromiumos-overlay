# Copyright 2017 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="647ae8297f5af57dce5859b0cf906e9bd4e64b80"
CROS_WORKON_TREE=("6836462cc3ac7e9ff3ce4e355c68c389eb402bff" "e2518fa4a96d03c88ae29f3289556df3c0f4a386" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
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
