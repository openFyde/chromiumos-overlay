# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="ce76df5e27813421ef09e122cd4a5fe9e8201e3b"
CROS_WORKON_TREE=("3e460a1cdb177bcebbb5ba7ad77043b23d5f5a65" "4ef81809377ecc6608239a3bd8f05ada10332ec2" "b951d30146bc87d2f2abb5f03ae33a6426ab52bb" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
}
