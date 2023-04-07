# Copyright 2019 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="523f65bbdb2773136cf776aad7c156142b352560"
CROS_WORKON_TREE=("5b87e97f3ddb9634fb1d975839c28e49503e94f8" "ea18793a930b3ff70fb6bb7bca1385938fb2ffab" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
CROS_WORKON_INCREMENTAL_BUILD="1"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk arc/container/myfiles .gn"

inherit cros-workon

DESCRIPTION="Container to run Android's MyFiles daemon."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/arc/container/myfiles"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="android-container-rvc"

RDEPEND="chromeos-base/mount-passthrough
	!<chromeos-base/chromeos-cheets-scripts-0.0.2-r470
"

src_install() {
	insinto /etc/init
	doins arc/container/myfiles/arc-myfiles.conf

	# These mount points are not used in Container-R.
	if ! use android-container-rvc; then
		doins arc/container/myfiles/arc-myfiles-default.conf
		doins arc/container/myfiles/arc-myfiles-read.conf
		doins arc/container/myfiles/arc-myfiles-write.conf
	fi
}
