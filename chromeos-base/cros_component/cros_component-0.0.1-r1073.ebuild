# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="5"
CROS_WORKON_COMMIT="682cb03170c0fc03f0800537dfc6bde4eb54c7a6"
CROS_WORKON_TREE=("4c23cb26be092f90ba8160118d643548e3a14a89" "16ad8ed8db2b38acd20dc93f698d79f9a66b3db8" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk cros_component .gn"

PLATFORM_SUBDIR="cros_component"

inherit cros-workon platform

DESCRIPTION="Configurations for Chrome OS universial installer"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/cros_component/"
SRC_URI=""

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"

src_compile() {
	true
}

src_install() {
	insinto /etc
	doins cros_component.config
}
