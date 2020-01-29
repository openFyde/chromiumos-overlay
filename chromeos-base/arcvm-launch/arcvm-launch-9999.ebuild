# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_INCREMENTAL_BUILD="1"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk arc/vm/launch .gn"

inherit cros-workon

# TODO(b/142424802): Rename the package to e.g. arcvm-common-scripts.
DESCRIPTION="A package to run arcvm."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/arc/vm/launch"

LICENSE="BSD-Google"
KEYWORDS="~*"

src_install() {
	insinto /etc/init
	doins arc/vm/launch/init/arcvm-host.conf
	doins arc/vm/launch/init/arcvm-ureadahead.conf

	insinto /usr/share/arcvm
	doins arc/vm/launch/init/config.json
}
