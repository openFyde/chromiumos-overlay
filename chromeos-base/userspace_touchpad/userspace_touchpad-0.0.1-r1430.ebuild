# Copyright 2016 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="f5905cb27d9b5dbf6bf6e338cf012ba9267a0523"
CROS_WORKON_TREE=("4d05be6aacce39f0ffed0cb00fc7d88926121b65" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_DESTDIR="${S}"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk userspace_touchpad .gn"

PLATFORM_SUBDIR="userspace_touchpad"

inherit cros-workon platform

DESCRIPTION="Userspace Touchpad"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/userspace_touchpad/"
SRC_URI=""

LICENSE="BSD-Google"
SLOT="0/0"
IUSE=""
KEYWORDS="*"

src_install() {
	platform_src_install

	dobin "${OUT}/userspace_touchpad"

	insinto "/etc/init"
	doins "userspace_touchpad.conf"
}
