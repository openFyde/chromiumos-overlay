# Copyright 2011 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="3ec12e2373c16d05db0fcc928706017476a3b955"
CROS_WORKON_TREE="d13aecbddd6264ff42e0b0a015fa976549fcac88"
CROS_WORKON_PROJECT="chromiumos/platform/crostestutils"
CROS_WORKON_LOCALNAME="crostestutils"
CROS_WORKON_SUBTREE="recover_duts"

inherit cros-workon

DESCRIPTION="Test tool that recovers bricked Chromium OS test devices"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/crostestutils/+/master/recover_duts/"

LICENSE="BSD-Google"
SLOT="0/0"
KEYWORDS="*"

RDEPEND="
	chromeos-base/chromeos-init
"

DEPEND=""

src_unpack() {
	cros-workon_src_unpack
	S+="/recover_duts"
}

src_install() {
	dosbin reload_network_device

	exeinto /usr/libexec/recover-duts
	newexe recover_duts.sh recover_duts

	exeinto /usr/libexec/recover-duts/hooks
	doexe hooks/*
}
