# Copyright 2015 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

CROS_WORKON_COMMIT="c5e129fb04bd33feb66f15cbcea3b816b1805d69"
CROS_WORKON_TREE=("abb168d9ecda9d00ce3e63c48d60028b32492066" "a1fe73d0411a7b197d9434d702f88969762c779c" "dc1506ef7c8cfd2c5ffd1809dac05596ec18773c")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk trim .gn"

PLATFORM_SUBDIR="trim"

inherit cros-workon platform

DESCRIPTION="Stateful partition periodic trimmer"
HOMEPAGE="http://www.chromium.org/"
SRC_URI=""

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE=""

DEPEND=""

RDEPEND="${DEPEND}
	chromeos-base/chromeos-common-script
	chromeos-base/chromeos-init
	sys-apps/util-linux"

platform_pkg_test() {
	platform_test "run" "tests/chromeos-trim-test"
	platform_test "run" "tests/chromeos-do_trim-test"
}

src_install() {
	insinto "/etc/init"
	doins "init/trim.conf"

	insinto "/usr/share/cros"
	doins "share/trim_utils.sh"

	dosbin "scripts/chromeos-trim"
}
