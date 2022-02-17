# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="46a8b555be9aa9302daf18e96b90b4d7918c757f"
CROS_WORKON_TREE=("adb7e529d9a6937314eaebaf0b47b08a1c154a07" "e5bcc7178d0dbbdf73e1b08b8496c182f7a04a1e" "929473dc551da68ad25453a477c95767c65e9e22" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
