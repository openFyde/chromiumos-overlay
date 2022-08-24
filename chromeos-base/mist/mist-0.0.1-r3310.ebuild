# Copyright 2014 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=6
CROS_WORKON_COMMIT="df00d6e3095f0112f83500e5452608c535f046e2"
CROS_WORKON_TREE=("9ca78a2d46421d17d297bbb13b05eebbb51d330a" "19f36342be7994842e12ce8eadbb21be2e51ae97" "4ec2fa4d5c39ef8f7ff31b3d41e38249461e55f7" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_OUTOFTREE_BUILD=1
# TODO(crbug.com/809389): Avoid directly including headers from other packages.
CROS_WORKON_SUBTREE="common-mk metrics mist .gn"

PLATFORM_SUBDIR="mist"

inherit cros-workon platform udev

DESCRIPTION="Chromium OS Modem Interface Switching Tool"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/mist/"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE=""

RDEPEND="
	chromeos-base/libbrillo:=[udev]
	>=chromeos-base/metrics-0.0.1-r3152
	dev-libs/protobuf:=
	net-dialup/ppp
	virtual/libusb:1
	virtual/udev
"

DEPEND="${RDEPEND}"

platform_pkg_test() {
	platform test_all
}

src_install() {
	platform_install

	udev_dorules 51-mist.rules
}
