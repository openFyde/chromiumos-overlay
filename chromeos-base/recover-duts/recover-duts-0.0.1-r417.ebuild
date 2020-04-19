# Copyright (c) 2011 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="4580b7328b7dc4dd9953bec17c102efefbe0a165"
CROS_WORKON_TREE="5bb3bef9dea46ab82ccbd69275a253d5941b4987"
CROS_WORKON_PROJECT="chromiumos/platform/crostestutils"
CROS_WORKON_LOCALNAME="crostestutils"
CROS_WORKON_SUBTREE="recover_duts"

inherit cros-workon

DESCRIPTION="Test tool that recovers bricked Chromium OS test devices"
HOMEPAGE="http://www.chromium.org/"

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
