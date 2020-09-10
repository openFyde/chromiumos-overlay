# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_WORKON_COMMIT="f1d892b43c2170b8960364f75585484ed0a4448f"
CROS_WORKON_TREE=("b2d7995ab106fbf61493d108c2bfd78d1a721d83" "555469a5e41621f091ace429fc9819cc99bb1a37" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_DESTDIR="${S}/platform2"
CROS_WORKON_SUBTREE="common-mk typecd .gn"

PLATFORM_SUBDIR="typecd"

inherit cros-workon platform user

DESCRIPTION="Chrome OS USB Type C daemon"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/typecd/"

LICENSE="BSD-Google"
SLOT=0
KEYWORDS="*"
IUSE="+seccomp"

src_install() {
	dobin "${OUT}"/typecd

	insinto /etc/init
	doins init/*.conf

	# Install seccomp policy file.
	insinto /usr/share/policy
	use seccomp && newins "seccomp/typecd-seccomp-${ARCH}.policy" typecd-seccomp.policy

	# Install rsyslog config.
	insinto /etc/rsyslog.d
	doins rsyslog/rsyslog.typecd.conf
}

pkg_preinst() {
	enewuser typecd
	enewgroup typecd
}

platform_pkg_test() {
	platform_test "run" "${OUT}/typecd_testrunner"
}
