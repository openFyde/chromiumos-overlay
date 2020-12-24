# Copyright (c) 2012 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
CROS_WORKON_COMMIT="dc2a3fe8d1a0cc593a0532a2d2bd9be4d2507aec"
CROS_WORKON_TREE="fb9ead379c6de47f8f051c3460a4f382026edcd1"
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

# File cryptohome-dbus-perf.conf moved from hwsec-test-utils.
RDEPEND="!<chromeos-base/hwsec-test-utils-0.0.1-r83"

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
