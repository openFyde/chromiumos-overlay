# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="f1c64ae0bbfc7ae2b3bd779c02081aefd6cc5d66"
CROS_WORKON_TREE=("6cadd9f53ad2c518aa18312d8ea45915a3dd112a" "92890e6f2f2e2116a9eac7c4f06b693a01007dd0" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD="1"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk arc/vm/scripts .gn"

inherit cros-workon

DESCRIPTION="ARCVM common scripts."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/arc/vm/scripts"

LICENSE="BSD-Google"
KEYWORDS="*"

RDEPEND="
	${RDEPEND}
	chromeos-base/arcvm-mount-media-dirs
"

src_install() {
	insinto /etc/init
	doins arc/vm/scripts/init/arcvm-fsverity-certs.conf
	doins arc/vm/scripts/init/arcvm-host.conf
	doins arc/vm/scripts/init/arcvm-ureadahead.conf

	insinto /usr/share/arcvm
	doins arc/vm/scripts/init/config.json

	insinto /usr/share/arcvm/fsverity-certs
	doins arc/vm/scripts/init/certs/fsverity-release.x509.der
	doins arc/vm/scripts/init/certs/play_store_fsi_cert.der
}
