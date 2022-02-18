# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="5d9e35b8aed6e1af82447620cd2dfb0102e5a7b1"
CROS_WORKON_TREE=("a1485b27500f3f8a7cf4204d77b152d1c173e313" "04d918571ad6d12563589ccf1b8c0e79b65521aa" "929473dc551da68ad25453a477c95767c65e9e22" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD="1"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
# TODO(crbug.com/809389): Remove libmems from this list.
CROS_WORKON_SUBTREE="common-mk iioservice libmems .gn"

PLATFORM_SUBDIR="iioservice/iioservice_simpleclient"

inherit cros-workon platform

DESCRIPTION="A simple client to test iioservice's mojo IPC for Chromium OS."

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE=""

RDEPEND="
	chromeos-base/libiioservice_ipc:=
	chromeos-base/libmems:=
"

DEPEND="${RDEPEND}
	chromeos-base/system_api:=
"

src_install() {
	dosbin "${OUT}"/iioservice_simpleclient
	dosbin "${OUT}"/iioservice_query
}
