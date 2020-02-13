# Copyright (c) 2012 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
CROS_WORKON_COMMIT="19d049500b81718b1b778ac41133a0f149b7e4a9"
CROS_WORKON_TREE="9a34553ae659ebcbcfd4e388fc034367973dcba2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_DESTDIR="${S}"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="init/upstart/test-init"

inherit cros-workon

DESCRIPTION="Additional upstart jobs that will be installed on test images"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/init/"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE="+encrypted_stateful tpm2"

src_unpack() {
	cros-workon_src_unpack
	S+="/init"
}

src_install() {
	insinto /etc/init
	doins upstart/test-init/*.conf

	insinto /usr/share/cros
	doins upstart/test-init/*_utils.sh

	if use encrypted_stateful && use tpm2; then
		insinto /etc/init
		doins upstart/test-init/encrypted_stateful/create-system-key.conf

		insinto /usr/share/cros
		doins upstart/test-init/encrypted_stateful/system_key_utils.sh
	fi
}
