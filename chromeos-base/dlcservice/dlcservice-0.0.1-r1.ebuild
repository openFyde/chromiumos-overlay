# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT="c24537b049290fa308240d4ed214e500624d2541"
CROS_WORKON_TREE=("2fbf3369a444e70d6320c89efbced5d7ddf79efb" "df41f9e80b5b1aeb88051029e9b28229d64b9cb8")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk dlcservice"

PLATFORM_SUBDIR="dlcservice"

inherit cros-workon platform user

DESCRIPTION="A D-Bus service for Downloadable Content (DLC)"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/dlcservice/"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE=""

RDEPEND="chromeos-base/libbrillo"

DEPEND="${RDEPEND}
	chromeos-base/system_api"

src_install() {
	dosbin "${OUT}/dlcservice"

	# Seccomp policy files.
	insinto /usr/share/policy
	newins seccomp/dlcservice-seccomp-${ARCH}.policy \
		dlcservice-seccomp.policy

	# Upstart configuration
	insinto /etc/init
	doins dlcservice.conf

	# D-Bus configuration
	insinto /etc/dbus-1/system.d
	doins org.chromium.DlcService.conf
}

pkg_preinst() {
	enewuser "dlcservice"
	enewgroup "dlcservice"
}
